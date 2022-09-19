from konlpy.tag import Mecab
from math import log
import pickle
import os
import sys

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
from config import config

import warnings
warnings.simplefilter("ignore")

DF_SAVE_PATH = config.DF_SAVED_PATH
    
class ToTTfidfVectorizer():
    def __init__(self, stopwords: list = None) -> None:
        self.stopwords = stopwords
        self.tokenizer = Mecab()
        self.docs = None
        self.N_docs = 0
        self.vocab = None
        # if DF saved in disk, load it
        try:
            with open(DF_SAVE_PATH, 'rb') as fp: 
                self.df = pickle.load(fp)
        except FileNotFoundError:
            self.df = None

    def load_vocab(self, docs: list) -> list:
        vocab = []
        for d in docs:
            tokens_ = self.tokenizer.nouns(d)
            for tok in tokens_:
                if tok.isalpha() and len(tok) != 1:
                    vocab.append(tok)
        return sorted(list(set(vocab)))

    def fit(self, docs: list) -> None:
        self.docs = docs
        self.N_docs = len(docs)
        self.vocab = self.load_vocab(docs)
        self.df = {}
        for t in self.vocab:
            df = 0
            for d in docs:
                df += t in d
            self.df[t] = df
        # save DF to disk
        with open(DF_SAVE_PATH, 'wb') as fp:
            pickle.dump(self.df, fp)


    def transform(self, d: str) -> dict:
        tokens_ = self.load_vocab([d])
        tfidf_ = {}
        for t in tokens_:
            tf_ = d.count(t)
            try:
                df_ = self.df[t]
                tfidf_[t] = tf_ * log(self.N_docs/(df_ + 1))
            
                self.df[t] += 1
            except:
                tfidf_[t] = tf_ * log(self.N_docs)
                
                self.df[t] = 1
                
        # save updated DF to disk
        with open(DF_SAVE_PATH, 'wb') as fp:
            pickle.dump(self.df, fp)
        return tfidf_
    
    def get_keyword_names(self, d: str, N_keywords: int = 5) -> list:
        tfidf_ = self.transform(d)
        sorted_dict = sorted(tfidf_.items(), key = lambda item: item[1], reverse = True)
        
        keywords = [x for (x, y) in sorted_dict[:N_keywords]]
        return keywords