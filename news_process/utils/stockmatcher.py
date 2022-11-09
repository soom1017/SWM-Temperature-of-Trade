# -*- coding: utf-8 -*-
from neo4j import GraphDatabase
import numpy as np
import pandas as pd
from config import config, load_substitute_data

driver = GraphDatabase.driver("bolt://test4j:7687", auth=("neo4j", "test"))

possible_stock_df = pd.read_csv(config.STOCK_LIST_PATH)
possible_stocks = possible_stock_df["name"].values.tolist()
exceptional_stocks = [
    "대상", "CS"
]
general_keywords = [
    "금리", "금융", "통화", "대출", "융자"
]
default_weight = 8

def run_query(input_query):
    with driver.session() as session: 
        results = session.run(input_query)
        return list(results)
    
def softmax(x):
    x = np.exp(np.array(x))
    sum_x = np.sum(x)
    out = x / sum_x
    return out

    
class StockMatcher:
    def __init__(self):
        self.prob = None
        self.substitutes = load_substitute_data()
    
    def ignore_parent_company(self, matched: list):
        stocks = ' '.join(matched)
        real_matched = [st for st in matched if stocks.count(st) == 1]
        return real_matched
                
    def execute_exactly_matching(self, text: str):
        # 축약어, 변형된 종목명을 원하는 단어형태로. ex. '한전' -> '한국전력'
        for k in self.substitutes.keys():
            text.replace(k, self.substitutes[k])
            
        exactly_matched = []
        for st in possible_stocks:
            # 대상기업, CS기업 등등 잘 나오는 단어의 기업들: '대상' 말고 '대상기업'만 인정
            if st in exceptional_stocks:
                if st+'기업' in text:
                    exactly_matched.append(st)
                else:
                    continue
            if st in text:
                exactly_matched.append(st)
        # 종목명이 포함관계인 계열사, ex. '카카오', '카카오페이'는 더 구체적인 종목(계열사 이름)으로
        exactly_matched = self.ignore_parent_company(exactly_matched)
        return exactly_matched
    
    def bfs_stock_from_keyword(self, keyword_name: str, keyword_weight: float):
        found = False
        weight = default_weight
        
        keywords = [keyword_name]
        depth = 0
        while not found and depth < 3:
            relatedWrds_query = f"MATCH (k)-[r:re]->(m) WHERE k.name IN {keywords} WITH m, count(m) as rels WHERE rels > 25 RETURN DISTINCT m.name AS `name`, labels(m)[0] AS `type`;"
            relatedWrds = run_query(relatedWrds_query)
            
            keywords = []
            for node in relatedWrds:
                keyword = node['name']
                if keyword in possible_stocks:
                    self.prob[keyword] += weight * keyword_weight
                    found = True
                else:
                    keywords.append(keyword)
                    
            depth += 1
            weight /= 2
            
    def rearrange_prob(self, stock_prob: dict):
        stock = list(stock_prob.keys())
        prob_val = list(stock_prob.values())
        prob_val = softmax(prob_val)
        prob_val = [round(val, 4) * 100 for val in prob_val if round(val, 4)]
        # 처음 세개합 < 70: 종합
        if len(prob_val) > 3 and sum(prob_val[:3]) < 50:
            return "종합", ""
        # 맨 끝 25 내외 정도는 '기타'로 처리
        etc, prev = 0, 0
        for i, val in enumerate(sorted(prob_val)):
            if etc + prev > 25 or etc + prev > val:
                break
            etc += prev
            prev = val
            
        if etc:
            prob_val = prob_val[:-i] + [etc]
            stock = stock[:-i] + ["기타"]
        # 더해서 100 나오도록
        prob_val[-1] = round(prob_val[-1] + (100 - sum(prob_val)), 2)
            
        return stock[0], {stock[i]: prob_val[i] for i in range(len(prob_val)) if prob_val[i]}
        
    
    def get_attention_stock(self, text: str, tfidf: dict, N: int = 5):        
        # try exact-matching
        exactly_matched = self.execute_exactly_matching(text)
        if exactly_matched:
            if len(exactly_matched) > 5:
                return "종합", ""
            
            prob = {st: text.count(st) for st in exactly_matched}
            sorted_prob = sorted(prob.items(), key=lambda item: item[1], reverse=True)
            return self.rearrange_prob(dict(sorted_prob))
        
        for k in general_keywords:
            if k in text:
                return "종합", ""
        # no matched stocks, then try graph-matching
        self.prob = {stock : 0 for stock in possible_stocks}
        keywords = tfidf.keys()
        for key in keywords:
            self.bfs_stock_from_keyword(key, tfidf[key])
            
        sorted_prob = sorted(self.prob.items(), key=lambda item: item[1], reverse=True)[:N]
        if not sorted_prob[0][1]:
            return "종합", ""
        return self.rearrange_prob(dict(sorted_prob))

