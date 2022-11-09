from sqlalchemy import INTEGER, VARCHAR, Float, Table, Column, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship

from .database import Base

user_bookmark = Table(
    "user_bookmark",
    Base.metadata,
    Column('user_id', Integer, ForeignKey("user.id")),
    Column('news_id', Integer, ForeignKey("news.id"))
)     

user_stocks = Table(
    "user_stocks",
    Base.metadata,
    Column('user_id', Integer, ForeignKey("user.id")),
    Column('stock_name', VARCHAR(45), ForeignKey("stock.name"))
)      
    
user_keywords = Table(
    "user_keywords",
    Base.metadata,
    Column('user_id', Integer, ForeignKey("user.id")),
    Column('keyword_name', VARCHAR(45), ForeignKey("keyword.name"))
)
    
news_keywords = Table(
    "news_keywords",
    Base.metadata,
    Column('news_id', Integer, ForeignKey("news.id")),
    Column('keyword_name', VARCHAR(45), ForeignKey("keyword.name"))
)

class User(Base):
    __tablename__ = "user"
    
    id = Column(INTEGER, primary_key=True, autoincrement=True)
    user_id = Column(VARCHAR(128), nullable=False)
    token = Column(VARCHAR(255))
    main_page = Column(Integer)
    
    news = relationship('News', secondary=user_bookmark, back_populates="user")
    keyword = relationship('Keyword', secondary=user_keywords, back_populates="user")
    stock = relationship('Stock', secondary=user_stocks, back_populates="user")
    
class News(Base):
    __tablename__ = "news"
    
    id = Column(Integer, primary_key=True)
    title = Column(VARCHAR(100), unique=True, nullable=False)
    body = Column(Text)
    reporter = Column(VARCHAR(45))
    press = Column(VARCHAR(45))
    created_at = Column(DateTime)
    highlight_idx = Column(VARCHAR(45))
    summary = Column(Text)
    attention_stock = Column(VARCHAR(45), ForeignKey("stock.name"))
    stock_prob = Column(VARCHAR(45))
    label = Column(Integer)
    score = Column(Float)
    views = Column(Integer, nullable=False)
    
    user = relationship('User', secondary=user_bookmark, back_populates="news")
    keyword = relationship('Keyword', secondary=news_keywords, back_populates="news")

class Stock(Base):
    __tablename__ = "stock"
    
    name = Column(VARCHAR(20), primary_key=True)
    
    user = relationship('User', secondary=user_stocks, back_populates="stock")
    news = relationship('News')
    
class Keyword(Base):
    __tablename__ = "keyword"
    
    name = Column(VARCHAR(20), primary_key=True)
    
    user = relationship('User', secondary=user_keywords, back_populates="keyword")
    news = relationship('News', secondary=news_keywords, back_populates="keyword")
    