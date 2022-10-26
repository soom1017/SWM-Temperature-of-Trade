from konlpy.tag import Mecab
from math import log
import pickle
import os
import sys
import pandas as pd

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
from config import config

import warnings
warnings.simplefilter("ignore")

DATA_SAVE_PATH = config.DF_SAVED_PATH
    
def load_data():
    try:
        with open(DATA_SAVE_PATH, 'rb') as fp: 
            df = pickle.load(fp)
    except FileNotFoundError:
        df = None
        
    return df

def update_data(data):
    with open(DATA_SAVE_PATH, 'wb') as fp:
        pickle.dump(data, fp)
        
### Keyword Extractor Module
class ToTTfidfVectorizer():
    def __init__(self):
        self.tokenizer = Mecab()
        self.data = load_data()
        self.tfidf = None
        
            
    def get_vocab(self, docs: list):
        vocab = []
        for d in docs:
            tokens = self.tokenizer.nouns(d)
            for t in tokens:
                if t.isalpha() and len(t) != 1:
                    vocab.append(t)
        return sorted(list(set(vocab)))

    def fit(self, docs: list):
        N_docs = len(docs)
        tokens = self.get_vocab(docs)
        self.data = {"N_docs": N_docs}
        
        for t in tokens:
            df = 0
            for d in docs:
                df += t in d
            self.data[t] = df
        update_data(self.data)

    def transform(self, d: str):
        self.data["N_docs"] += 1
        N_docs = self.data["N_docs"]
        tokens = self.get_vocab([d])
        
        tfidf = {}
        for t in tokens:
            tf = d.count(t)
            try:            
                self.data[t] += 1
            except:
                self.data[t] = 1
            df = self.data[t]
            tfidf[t] = tf * log(N_docs/(df))
        update_data(self.data)
        
        self.tfidf = dict(sorted(tfidf.items(), key = lambda item: item[1], reverse = True))
        return self.tfidf
    
    def get_keyword_names(self, N_keywords: int = 3):
        data = list(self.tfidf.items())
        keywords = [x for (x, y) in data[:N_keywords]]
        return keywords