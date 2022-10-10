import re, math
from typing import Tuple
import torch
import numpy as np
from kobart import get_kobart_tokenizer
from transformers.models.bart import BartForConditionalGeneration

def jaccard_similarity(A, B) -> float:
    union = set(A).union(set(B))
    intersection = set(A).intersection(set(B))
    return len(intersection) / len(union)
    
class SummaryGenerator():
    def __init__(self) -> None:
        self.model = BartForConditionalGeneration.from_pretrained('./kobart_summary')
        self.tokenizer = get_kobart_tokenizer()
        self.sentences = None
        self.num_sentences = None
        self.summary_ids = None
        
    
    def get_sentences(self, text: str) -> list:
        result = []
        count = 0
        
        paragraphs = text.split("\r")
        for para in paragraphs:
            raw_sentences = re.split('\n|\t|\.', para)
            sentences = []

            for i in range(len(raw_sentences)):
                st = raw_sentences[i].strip()
                if st == '':
                    continue
                if re.search(r'\d+$', st):
                    raw_sentences[i+1] = '.'.join([st, raw_sentences[i+1]])
                    continue
                sentences.append(st + '.')
                count += 1
            result.append(sentences)
            
        self.num_sentences = count
        return result
        
    def get_token_ids(self, text: str) -> list:
        raw_input_ids = self.tokenizer.encode(text)
        input_ids = [self.tokenizer.bos_token_id] + raw_input_ids + [self.tokenizer.eos_token_id]
        return input_ids
    
    def get_model_output(self, input_ids: list) -> Tuple[str, list]:
        output = self.model.generate(torch.tensor([input_ids]),  num_beams=4,  max_length=512,  eos_token_id=1)
        summary = self.tokenizer.decode(output.squeeze().tolist(), skip_special_tokens=True)

        output = output.squeeze().numpy()
        np.delete(output, 0)
        np.delete(output, -1)
        
        return summary, output

    def get_summary(self, text: str) -> str:
        self.sentences = self.get_sentences(text)
        input_ids = self.get_token_ids(text)   
        
        # handles too long article
        if len(input_ids) > 1026:
            summary = ""
            self.summary_ids = []
            
            for para in self.sentences:
                if len(para) < 2:
                    continue
                p_raw_input_ids = []
                for st in para:
                    p_raw_input_ids += self.tokenizer.encode(st)
                p_input_ids = [self.tokenizer.bos_token_id] + p_raw_input_ids + [self.tokenizer.eos_token_id]
                p_summary, p_summary_ids = self.get_model_output(p_input_ids)
                
                summary += p_summary + " "
                self.summary_ids = np.concatenate((self.summary_ids, p_summary_ids[1:-1]), axis=0)
            self.summary_ids = np.concatenate(([self.tokenizer.bos_token_id], self.summary_ids[1:], [self.tokenizer.eos_token_id]), axis=0)
                
            return summary
        # handles article w/ normal length
        summary, self.summary_ids = self.get_model_output(input_ids)
        return summary
    

    def get_indexes(self, N: int) -> list:
        idxes_ = []
        similarity_ = []

        for para in self.sentences:
            for st in para:
                st = st.strip()
                st_ids = self.tokenizer.encode(st)

                similarity_.append(jaccard_similarity(self.summary_ids, st_ids))

        idx = range(len(similarity_))
        for (i, j) in sorted(zip(similarity_, idx), reverse=True)[:N]:
            idxes_.append(idx[j])

        return idxes_

    def get_highlight_indexes(self) -> list:
        if (self.sentences == None) or (self.summary_ids is None):
            raise Exception()
        
        if self.num_sentences > 5:
            num_idx = math.ceil(math.log(self.num_sentences))
            highlight_indexes = self.get_indexes(num_idx)
            return highlight_indexes
        
        return None