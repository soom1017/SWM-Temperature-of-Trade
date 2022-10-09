from sqlalchemy import Table, Column, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship

from .database import Base

user_bookmark_news = Table(
    "user_bookmark_news",
    Base.metadata,
    Column('user_id', Integer, ForeignKey("user.id")),
    Column('news_id', Integer, ForeignKey("news.id"))
)     

user_attention_stocks = Table(
    "user_attention_stocks",
    Base.metadata,
    Column('user_id', Integer, ForeignKey("user.id")),
    Column('stock_id', Integer, ForeignKey("stock.name"))
)      
    
user_attention_keywords = Table(
    "user_attention_keywords",
    Base.metadata,
    Column('user_id', Integer, ForeignKey("user.id")),
    Column('keyword_id', Integer, ForeignKey("keyword.name"))
)
    
news_keywords = Table(
    "news_keywords",
    Base.metadata,
    Column('news_id', Integer, ForeignKey("news.id")),
    Column('keyword_id', Integer, ForeignKey("keyword.name"))
)

class User(Base):
    __tablename__ = "user"
    
    id = Column(String(50), primary_key=True)
    access_token = Column(String(50))
    main_page_id = Column(Integer)
    
    news = relationship('News', secondary=user_bookmark_news, back_populates="user")
    keyword = relationship('Keyword', secondary=user_attention_keywords, back_populates="user")
    stock = relationship('Stock', secondary=user_attention_stocks, back_populates="user")
    
class News(Base):
    __tablename__ = "news"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(50), unique=True, nullable=False)
    reporter = Column(String(20))
    press = Column(String(20))
    created_at = Column(DateTime)
    body = Column(Text)
    highlight_indexes = Column(String(50))
    summary = Column(Text)
    attention_stock_id = Column(String, ForeignKey("stock.name"))
    stock_prob = Column(String(50))
    temperature = Column(Integer)
    
    user = relationship('User', secondary=user_bookmark_news, back_populates="news")
    keyword = relationship('Keyword', secondary=news_keywords, back_populates="news")

class Stock(Base):
    __tablename__ = "stock"
    
    name = Column(String(20), primary_key=True)
    
    user = relationship('User', secondary=user_attention_stocks, back_populates="stock")
    news = relationship('News')
    
class Keyword(Base):
    __tablename__ = "keyword"
    
    name = Column(String(20), primary_key=True)
    
    user = relationship('User', secondary=user_attention_keywords, back_populates="keyword")
    news = relationship('News', secondary=news_keywords, back_populates="keyword")
    