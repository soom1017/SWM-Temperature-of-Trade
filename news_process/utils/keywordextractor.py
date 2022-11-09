from konlpy.tag import Mecab
from math import log
import os
import sys

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
from config import update_df_data, load_df_data, load_substitute_data

import warnings
warnings.simplefilter("ignore")

        
### Keyword Extractor Module
class ToTTfidfVectorizer():
    def __init__(self):
        self.tokenizer = Mecab()
        self.df = load_df_data()
        self.tfidf = None
        self.substitute = load_substitute_data()
            
    def get_vocab(self, docs: list):
        vocab = []
        for d in docs:
            tokens = self.tokenizer.nouns(d)
            for t in tokens:
                if t.isalpha() and len(t) != 1:
                    vocab.append(self.substitute[t] if t in self.substitute.keys() else t)
        return sorted(list(set(vocab)))

    def fit(self, docs: list):
        N_docs = len(docs)
        tokens = self.get_vocab(docs)
        self.df = {"N_docs": N_docs}
        
        for t in tokens:
            df = 0
            for d in docs:
                df += t in d
            self.df[t] = df
        update_df_data(self.df)

    def transform(self, d: str):
        self.df["N_docs"] += 1
        N_docs = self.df["N_docs"]
        tokens = self.get_vocab([d])
        
        tfidf = {}
        for t in tokens:
            tf = d.count(t)
            try:            
                self.df[t] += 1
            except:
                self.df[t] = 1
            df = self.df[t]
            tfidf[t] = tf * log(N_docs/(df))
        update_df_data(self.df)
        
        self.tfidf = dict(sorted(tfidf.items(), key = lambda item: item[1], reverse = True))
        return self.tfidf
    
    def get_keyword_names(self, N_keywords: int = 50):
        data = list(self.tfidf.items())
        keywords = [x for (x, y) in data[:N_keywords]]
        return keywords