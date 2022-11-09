import pandas as pd
from fastapi import APIRouter

from app.crud.utils import get_update_time
from app.util.keywordcrawler import MapCrawler
from app.config import settings

HOT_KEYWORD_PATH = settings.HOT_KEYWORD_PATH
KEYWORD_LIST_PATH = settings.KEYWORD_LIST_PATH
STOCK_LIST_PATH = settings.STOCK_LIST_PATH

keywords = APIRouter()

@keywords.get('/')
async def get_keyword_list():
    keyword_df = pd.read_csv(KEYWORD_LIST_PATH)
    stock_df = pd.read_csv(STOCK_LIST_PATH)
    keywords = keyword_df["name"].values[1:].tolist()
    stocks = stock_df["name"].values.tolist()
    
    return {"keywords": keywords, "stocks": stocks}

@keywords.get('/rank')
async def get_keyword_rank():
    data_rank = pd.read_csv(HOT_KEYWORD_PATH)
    data = data_rank["name"].values.tolist()
    update_time = get_update_time('keyword')
    
    return {"data": data, "update_time": update_time}
        
@keywords.get('/map/{keyword_name}')
async def get_graph_map_by_keyword_name(keyword_name: str):
    mapCrawler_ = MapCrawler()
    data = mapCrawler_.get_map_data(keyword_name)
    
    return data