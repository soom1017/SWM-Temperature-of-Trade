from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel

class Keyword(BaseModel):
    name: str
        
class Stock(BaseModel):
    name: str
    
class News(BaseModel): 
    id: int
    title: str
    created_at: datetime = None
    attention_stock: Optional[str] = None
    keyword: Optional[List[Keyword]] = None
    
    class Config:
        orm_mode = True
                
class User(BaseModel):
    id: int
    main_page: int = 1
    news: Optional[List[News]] = None
    keyword: Optional[List[Keyword]] = None
    stock: Optional[List[Stock]] = None
    
class NewsOut(BaseModel):
    data: List[News] = None
    
    class Config:
        orm_mode = True
    
class NewsDetail(News): 
    reporter: Optional[str] = None
    press: Optional[str] = None
    body: str
    summary: Optional[str] = None
    highlight_idx: Optional[str] = None
    stock_prob: Optional[str] = None
    label: Optional[int] = None
    score: Optional[float] = None
    
    class Config:
        orm_mode = True