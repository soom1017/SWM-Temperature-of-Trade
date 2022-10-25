import pandas as pd
from fastapi import APIRouter

from app.util.keywordcrawler import MapCrawler
from app.config import settings

HOT_KEYWORD_PATH = settings.HOT_KEYWORD_PATH
KEYWORD_LIST_PATH = settings.KEYWORD_LIST_PATH

keywords = APIRouter()

@keywords.get('/')
async def get_keyword_list():
    df = pd.read_csv(KEYWORD_LIST_PATH)
    data = df["name"].values[1:].tolist()
    
    return {"data": data}

@keywords.get('/rank/{page_offset}')
async def get_keyword_rank(page_offset: int):
    start, end = page_offset * 15, (page_offset + 1) * 15
    
    data_rank = pd.read_csv(HOT_KEYWORD_PATH)
    data = data_rank["name"][start:end].values.tolist()
    
    return {"data": data, "fin": end}
        
@keywords.get('/map/{keyword_name}')
async def get_graph_map_by_keyword_name(keyword_name: str):
    mapCrawler_ = MapCrawler()
    data = mapCrawler_.get_map_data(keyword_name)
    
    return data