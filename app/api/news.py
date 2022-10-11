from typing import List
from fastapi import APIRouter, Depends, HTTPException
from pygments import highlight

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db import schemas, models

news = APIRouter()

@news.get('/{news_id}')
async def get_news_by_id(news_id: int, db: Session = Depends(get_db)):
    news = db.query(models.News).filter(models.News.id == news_id).first()
    if not news:
        raise HTTPException(status_code=404, detail="News not found")
    data = schemas.NewsDetailParsed(news)
    return {"data": data}

@news.get('/list-new/')
async def get_recent_news_list(db: Session = Depends(get_db)):
    news_list = db.query(models.News).order_by(models.News.created_at.desc()).all()
    
    data = []
    for news in news_list:
        data.append(schemas.NewsParsed(news))
    return {"data": data}
    
@news.get('/list-hot/')
async def get_hot_news_list(db: Session = Depends(get_db)):
    #TODO: define `hot`, then order by `hot`
    news_list = db.query(models.News).all()
    
    data = []
    for news in news_list:
        data.append(schemas.NewsParsed(news))
    return {"data": data}

@news.get('/keyword/{keyword_name}')
async def get_news_list_by_keyword(keyword_name: str, db: Session = Depends(get_db)):
    keyword = db.query(models.Keyword).filter(models.Keyword.name == keyword_name).first()
    if not keyword:
        raise HTTPException(status_code=404, detail="Keyword not found")
    news_list = keyword.news
    
    data = []
    for news in news_list:
        data.append(schemas.NewsParsed(news))
    return {"data": data}
    
