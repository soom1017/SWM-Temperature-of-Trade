from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel

# base models
class UserBase(BaseModel):
    name: str
    
    class Config:
        orm_mode = True
        
class KeywordBase(BaseModel):
    name: str
    
    class Config:
        orm_mode = True
        
class StockBase(BaseModel):
    name: str
    
    class Config:
        orm_mode = True
    
class NewsBase(BaseModel): 
    id: int
    title: str
    created_at: datetime = None
    attention_stock_id: Optional[int] = None
    keyword: Optional[List[KeywordBase]] = None
    
    class Config:
        orm_mode = True
        
# actual database models
class User(UserBase):
    id: int
    main_page_id: int = 1
    auth_key: str
    news: Optional[List[NewsBase]] = None
    keyword: Optional[List[KeywordBase]] = None
    stock: Optional[List[StockBase]] = None
        
class Keyword(KeywordBase):
    id: int

class Stock(StockBase):
    id: int
    
class NewsDetail(NewsBase): 
    reporter: Optional[str] = None
    press: Optional[str] = None
    body: str
    summary: Optional[str] = None
    highlight_indexes: Optional[str] = None
    stock_prob: Optional[str] = None
    temperature: Optional[str] = None
    
    class Config:
        orm_mode = True