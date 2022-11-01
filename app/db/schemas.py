from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel

class Keyword(BaseModel):
    name: str
    
    class Config:
        orm_mode = True
        
class Stock(BaseModel):
    name: str
    
    class Config:
        orm_mode = True
    
class News(BaseModel): 
    id: int
    title: str
    created_at: datetime = None
    summary: Optional[str] = None
    attention_stock: Optional[str] = None
    keyword: Optional[List[Keyword]] = None
    
    class Config:
        orm_mode = True

class NewsParsed:
    def __init__(self, news: News):
        self.id = news.id
        self.title = news.title
        self.created_at = news.created_at
        self.summary = news.summary
        self.attention_stock = news.attention_stock
        self.keyword = []
        for k in news.keyword:
            self.keyword.append(k.name)

class NewsDetail(News):
    reporter: Optional[str] = None
    press: Optional[str] = None
    body: str
    highlight_idx: Optional[str] = None
    stock_prob: Optional[str] = None
    label: Optional[int] = None
    score: Optional[float] = None
    
class NewsDetailParsed(NewsParsed):
    def __init__(self, news: NewsDetail):
        super().__init__(news)
        self.reporter = news.reporter
        self.press = news.press
        self.body = eval(news.body)
        self.highlight_idx = eval(news.highlight_idx)
        self.stock_prob = eval(news.stock_prob) if news.stock_prob != "" else None
        self.label = news.label
        self.score = news.score
        