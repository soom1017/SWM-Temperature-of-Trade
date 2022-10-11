from fastapi import APIRouter, Depends, HTTPException

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.db.models import News, Keyword
from app.db.schemas import NewsDetailParsed
from app.config import settings

news = APIRouter()

def get_one_news_by_id(news_id: int, db: Session = Depends(get_db)):
    news = db.query(News).filter(News.id == news_id).first()
    if not news:
        raise HTTPException(status_code=404, detail="News not found")
    return news
    
@news.get('/{news_id}')
async def get_news_by_id(news_id: int, db: Session = Depends(get_db)):
    news = get_one_news_by_id(news_id, db)
    data = NewsDetailParsed(news)
    # leave a log - count news hits for `hot-news list`
    news.views = News.views + 1
    db.commit()
    return {"data": data}

@news.get('/list-new/{news_id}')
async def get_recent_news_list(news_id: int, db: Session = Depends(get_db)):
    if news_id == -1:
        news_list = db.query(News).order_by(News.created_at.desc()).limit(20).all()
    else:
        criterion = get_one_news_by_id(news_id, db)
        news_list = db.query(News).\
            filter(News.created_at < criterion.created_at).\
            order_by(News.created_at.desc()).\
            limit(20).all()
    
    data = []
    for news in news_list:
        data.append(NewsDetailParsed(news))
    return {"data": data}
    
@news.get('/list-hot/{news_id}')
async def get_hot_news_list(news_id: int, db: Session = Depends(get_db)):
    with open(settings.HOT_NEWSLIST_PATH, 'r') as f:
        dt = f.read()
        hot_news_ids = dt.split('\n')
        
    news_list = []
    if news_id == -1:
        for id in hot_news_ids[:20]:
            news_list.append(db.query(News).filter(News.id == int(id)).first())
    else:
        try:
            idx = hot_news_ids.index(str(news_id))
        except:
            raise HTTPException(status_code=404, detail="News not found")
        if idx != len(hot_news_ids) - 1:
            for id in hot_news_ids[idx+1:idx+21]:
                news_list.append(db.query(News).filter(News.id == int(id)).first())
            
    data = []
    for news in news_list:
        data.append(NewsDetailParsed(news))
    return {"data": data}

@news.get('/keyword/{keyword_name}/{news_id}')
async def get_news_list_by_keyword(keyword_name: str, news_id: int, db: Session = Depends(get_db)):
    if news_id == -1:
        news_list = db.query(News).\
            join(News.keyword).\
            filter(Keyword.name == keyword_name).\
            order_by(News.created_at.desc()).\
            limit(20).all()
    else:
        criterion = get_one_news_by_id(news_id, db)
        news_list = db.query(News).\
            join(News.keyword).\
            filter(Keyword.name == keyword_name, News.created_at < criterion.created_at).\
            order_by(News.created_at.desc()).\
            limit(20).all()
    data = []
    for news in news_list:
        data.append(NewsDetailParsed(news))
    return {"data": data}
    
