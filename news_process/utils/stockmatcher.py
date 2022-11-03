# -*- coding: utf-8 -*-
from neo4j import GraphDatabase
import numpy as np
  
driver = GraphDatabase.driver("bolt://test4j:7687", auth=("neo4j", "test"))
stocks = [
    "삼성전자", "LG에너지솔루션", "SK하이닉스", "삼성바이오로직스",
    "삼성SDI", "현대자동차","네이버",
    "포스코홀딩스", "삼성물산","현대모비스"
#   "신한지주", "SK이노베이션", "SK", "포스코케미칼",
#   "LG화학" ,"셀트리온","카카오","KB금융","기아","삼성전자우"
]
possible_stocks = [
    '삼성전자', 'LG에너지솔루션', '삼성바이오로직스', 'SK하이닉스', '삼성SDI',
    'LG화학', '삼성전자우', '현대자동차', '네이버', '셀트리온',
    '기아', '카카오', '삼성물산', 'POSCO홀딩스', '현대모비스',
    'KB금융', '신한지주', 'SK이노베이션', 'SK', '포스코케미칼',
    '삼성생명', 'LG전자', 'KT&G', '고려아연', 'LG',
    '하나금융지주', 'SK텔레콤', '한국전력', 'S-Oil', '현대중공업',
    '삼성에스디에스', 'KT', '삼성화재', 'HMM', '삼성전기',
    '한화솔루션', '크래프톤', '엔씨소프트', '우리금융지주', '대한항공',
    '두산에너빌리티', '카카오뱅크', 'LG생활건강', '기업은행', 'LG이노텍',
    '현대글로비스', 'CJ제일제당', 'SK바이오사이언스', 'F&F', '아모레퍼시픽', '포스코홀딩스'
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

def rearrange_prob(stock_prob: dict):
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
    # 더해서 100 나오는 거에 강박 있는 편
    prob_val[-1] = round(prob_val[-1] + (100 - sum(prob_val)), 2)
        
    return stock[0], {stock[i]: prob_val[i] for i in range(len(prob_val)) if prob_val[i]}
    
class StockMatcher:
    def __init__(self):
        self.prob = None
    
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
        
    
    def get_attention_stock(self, text: str, tfidf: dict, N: int = 5):        
        # try exact-matching
        exactly_matched = [st for st in possible_stocks if st in text]
        if exactly_matched:
            if len(exactly_matched) > 5:
                return "종합", ""
            
            prob = {st: text.count(st) for st in exactly_matched}
            sorted_prob = sorted(prob.items(), key=lambda item: item[1], reverse=True)
            return rearrange_prob(dict(sorted_prob))
        
        # no matched stocks, then try graph-matching
        self.prob = {stock : 0 for stock in possible_stocks}
        keywords = tfidf.keys()
        for key in keywords:
            self.bfs_stock_from_keyword(key, tfidf[key])
            
        sorted_prob = sorted(self.prob.items(), key=lambda item: item[1], reverse=True)[:N]
        if not sorted_prob[0][1]:
            return "종합", ""
        return rearrange_prob(dict(sorted_prob))

