from neo4j import GraphDatabase
from collections import deque
  
driver = GraphDatabase.driver("bolt://test4j:7687", auth=("neo4j", "test"))
stocks = [
    "삼성전자", "LG에너지솔루션", "SK하이닉스", "삼성바이오로직스", "삼성전자우", 
    "LG화학", "삼성SDI", "현대차", "기아", "NAVER", 
    "셀트리온", "카카오", "POSCO홀딩스", "삼성물산", "KB금융", 
    "현대모비스", "신한지주", "SK이노베이션", "SK", "포스코케미칼"
]
default_weight = 8

def run_query(input_query):
    with driver.session() as session: 
        results = session.run(input_query)
        return list(results)
    
class StockMatcher:
    def __init__(self):
        self.candidates_ = None
    
    def find_candidates_from_keyword(self, keyword_name: str, keyword_weight: float):
        self.candidates_ = {stock : 0 for stock in stocks}
        
        found = False
        weight = default_weight
        
        keywords = deque([keyword_name])
        depth = 1
        while not found and depth < 3:
            keyword_num = len(keywords)
            for i in range(keyword_num):
                keyword = keywords.popleft()
                relatedWrds_query = f"""
                        MATCH (k{{name: '{keyword}'}})-[r:re]->(m) 
                        RETURN DISTINCT m.name AS `name`, labels(m)[0] AS `type`;
                    """
                relatedWrds = run_query(relatedWrds_query)
                
                for object in relatedWrds:
                    if object['type'] == "Stock":
                        self.candidates_[object['name']] += weight * keyword_weight
                        found = True
                    else:
                        keywords.append(object['name'])
                    
            depth += 1
            weight /= 2
        
    
    def get_attention_stock(self, text: str, tfidf_: dict, N: int = 3):        
        # try exact-matching
        exactly_matched = []
        for stock in stocks:
            if stock in text:
                exactly_matched.append(stock)
                
        if exactly_matched:
            if len(exactly_matched) > 3:
                return "종합"
            
            candidates = {}
            for stock_name in exactly_matched:
                candidates[stock_name] = text.count(stock_name)
            candidates = sorted(candidates.items(), key=lambda item: item[1])
            
            attention_stock = candidates[0][0]
            self.candidates_ = dict(candidates)
            
            return attention_stock
        
        # no matched stocks, then try graph-matching
        sorted_dict = dict(sorted(tfidf_.items(), key=lambda item: item[1])[:N])
        for key in sorted_dict.keys():
            self.find_candidates_from_keyword(key, tfidf_[key])
            
        attention_stock = sorted(self.candidates_.items(), key=lambda item: item[1])[0][0]
        return attention_stock