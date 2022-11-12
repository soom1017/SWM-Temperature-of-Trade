import pandas as pd
from fastapi import APIRouter, Depends

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.crud.keywords import get_all_keywords
from app.crud.utils import get_update_time
from app.util.keywordcrawler import MapCrawler
from app.config import settings

HOT_KEYWORD_PATH = settings.HOT_KEYWORD_PATH

keywords = APIRouter()

@keywords.get('/')
async def get_keyword_list(db: Session = Depends(get_db)):
    keywords, stocks = get_all_keywords(db)
    
    return {"keywords": keywords, "stocks": stocks}

@keywords.get('/rank')
async def get_keyword_rank():
    data_rank = pd.read_csv(HOT_KEYWORD_PATH)
    data = data_rank["name"].values.tolist()[:20]
    update_time = get_update_time('keyword')
    
    return {"data": data, "update_time": update_time}
        
@keywords.get('/map/{keyword_name}')
async def get_graph_map_by_keyword_name(keyword_name: str):
    mapCrawler_ = MapCrawler()
    data = mapCrawler_.get_map_data(keyword_name)
    
    return data