from fastapi import Depends, HTTPException

from sqlalchemy import func, distinct, select
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.util.models import FilterData
from app.db.models import News, news_keywords
from app.db.schemas import NewsParsed
from app.config import settings

import datetime
import pickle

SENTIMENT_STATS_PATH = settings.SENTIMENT_STATS_PATH
HOT_NEWS_PATH = settings.HOT_NEWSLIST_PATH

## news
def get_one_news_by_id(news_id: int, db: Session = Depends(get_db)):
    db_news = db.query(News).filter(News.id == news_id).first()
    if not db_news:
        raise HTTPException(status_code=404, detail="News not found")
    return db_news

## news list
# parse news
def get_parsed_list_of(db_news_list: list):
    data = {
        "data": [NewsParsed(news) for news in db_news_list]
    }
    return data

# get list
def get_recent_news(news_id: int, db: Session = Depends(get_db)):
    if news_id == -1:
        db_news_list = db.query(News).order_by(News.created_at.desc()).limit(20).all()
    else:
        db_news_list = db.query(News).\
                            filter(News.id < news_id).\
                            limit(20).all()
            
    return get_parsed_list_of(db_news_list)

def get_hot_news(news_id: int, db: Session = Depends(get_db)):
    # read HOT_NEWSLIST (.txt)
    with open(HOT_NEWS_PATH, 'r') as f:
        dt = f.read()
        hot_news_ids = dt.split('\n')
        hot_news_ids = [id for id in hot_news_ids if id.strip() != ""]
        
    # get 20 news starts from `news_id`
    if news_id == -1:
        news_list = [get_one_news_by_id(id, db) for id in hot_news_ids[:20]]
    else:
        try:
            idx = hot_news_ids.index(str(news_id))
            if idx != len(hot_news_ids) - 1:
                news_list = [get_one_news_by_id(id, db) for id in hot_news_ids[idx+1:idx+21]]
        except:
            raise HTTPException(status_code=404, detail="News not found")
                
    return get_parsed_list_of(news_list)

# get filtered list
def get_news_by_keyword(news_id: int, keyword: str, db: Session = Depends(get_db)):
    stmt = select(distinct(news_keywords.c.news_id)).where(news_keywords.c.keyword_name == keyword)
    result = db.execute(stmt)
    ids = [r[0] for r in result]
    
    if news_id == -1:
        db_news_list = db.query(News).\
                            filter(News.id.in_(ids)).\
                            order_by(News.id.desc()).\
                            limit(20).all()
    else:
        db_news_list = db.query(News).\
                            filter(News.id.in_(ids), News.id < news_id).\
                            order_by(News.id.desc()).\
                            limit(20).all()
    
    return get_parsed_list_of(db_news_list)
    
def get_news_by_filter(news_id: int, filters: FilterData, db: Session = Depends(get_db)):
    stmt = select(distinct(news_keywords.c.news_id)).where(news_keywords.c.keyword_name.in_(filters.keywords))
    result = db.execute(stmt)
    ids = [r[0] for r in result]
    
    if news_id == -1:
        db_news_list = db.query(News).\
                            filter(((News.id.in_(ids)) | (News.attention_stock.in_(filters.stocks)))).\
                            order_by(News.id.desc()).\
                            limit(100).all()
    else:
        db_news_list = db.query(News).\
                            filter(((News.id.in_(ids)) | (News.attention_stock.in_(filters.stocks))), News.id < news_id).\
                            order_by(News.id.desc()).\
                            limit(100).all()
        
    return get_parsed_list_of(db_news_list)
    
## news stats
# sentiment stats
def get_sentiment_stats_on(date: str, db: Session = Depends(get_db)):
    stats = [0, 0, 0]
    db_labels = db.query(News.label).filter(func.DATE(News.created_at) == date).all()
    for label in db_labels:
        stats[label[0]] += 1
    return stats

def get_weekly_sentiment_stats(db: Session = Depends(get_db)):
    try:
        with open(SENTIMENT_STATS_PATH, 'rb') as f:
            stats = pickle.load(f)
    except:
        stats = {}
    stats_changed = False
    
    today = datetime.date.today()
    data = {
        today: get_sentiment_stats_on(today, db),
    }
    
    for i in range(1, 7):
        date = today - datetime.timedelta(days=i)
        try:
            data[date] = stats[date]
        except:
            data[date] = get_sentiment_stats_on(date, db)
            stats[date] = data[date]
            stats_changed = True
    
    if stats_changed:
        with open(SENTIMENT_STATS_PATH, 'wb') as f:
            pickle.dump(stats, f)
    return data