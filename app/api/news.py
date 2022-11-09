from fastapi import APIRouter, Depends

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.util.models import FilterData
from app.db.models import News
from app.db.schemas import NewsDetailParsed
from app.crud.utils import get_update_time
from app.crud.news import get_one_news_by_id, get_recent_news, get_hot_news, get_news_by_filter, get_news_by_keyword, get_weekly_sentiment_stats

news = APIRouter()
    
@news.get('/{news_id}')
async def get_news_by_id(news_id: int, db: Session = Depends(get_db)):
    db_news = get_one_news_by_id(news_id, db)
    data = NewsDetailParsed(db_news)
    # leave a log - count news hits for `hot-news list`
    db_news.views = News.views + 1
    db.commit()
    return {"data": data}

@news.get('/list-new/{news_id}')
async def get_recent_news_list(news_id: int, db: Session = Depends(get_db)):
    data = get_recent_news(news_id, db)
    return data
    
@news.get('/list-hot/{news_id}')
async def get_hot_news_list(news_id: int, db: Session = Depends(get_db)):
    data = get_hot_news(news_id, db)
    data['update_time'] = get_update_time('news')
    return data

@news.get('/keyword/{keyword_name}/{news_id}')
async def get_news_list_by_keyword(keyword_name: str, news_id: int, db: Session = Depends(get_db)):
    data = get_news_by_keyword(news_id, keyword_name, db)
    return data

@news.post('/list-filter/{news_id}')
async def get_news_list_by_filter(filters: FilterData, news_id: int, db: Session = Depends(get_db)):
    data = get_news_by_filter(news_id, filters, db)
    return data
    
@news.get('/stats-sentiment/')
async def get_sentiment_stats(db: Session = Depends(get_db)):
    data = get_weekly_sentiment_stats(db)
    return {"data": data}
