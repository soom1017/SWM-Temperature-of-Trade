import pandas as pd
from fastapi import APIRouter

from app.util.keywordcrawler import MapCrawler
from app.config import settings

HOT_KEYWORD_PATH = settings.HOT_KEYWORD_PATH
KEYWORD_LIST_PATH = settings.KEYWORD_LIST_PATH

keywords = APIRouter()

# stocks
possible_stocks = [
    '삼성전자', 'LG에너지솔루션', '삼성바이오로직스', 'SK하이닉스', '삼성SDI', 'LG화학', '삼성전자우', '현대자동차', '네이버', '셀트리온', '기아', '카카오', '삼성물산', 'POSCO홀딩스', '현대모비스', 'KB금융', '신한지주', 'SK이노베이션', 'SK', '포스코케미칼', '삼성생명', 'LG전자', 'KT&G', '고려아연', 'LG', '하나금융지주', 'SK텔레콤', '한국전력', 'S-Oil', '현대중공업', '삼성에스디에스', 'KT', '삼성화재', 'HMM', '삼성전기', '한화솔루션', '크래프톤', '엔씨소프트', '우리금융지주', '대한항공', '두산에너빌리티', '카카오뱅크', 'LG생활건강', '기업은행', 'LG이노텍', '현대글로비스', 'CJ제일제당', 'SK바이오사이언스', 'F&F', '아모레퍼시픽', '포스코홀딩스'
]

@keywords.get('/')
async def get_keyword_list():
    df = pd.read_csv(KEYWORD_LIST_PATH)
    keywords = df["name"].values[1:].tolist()
    stocks = possible_stocks
    
    return {"keywords": keywords, "stocks": stocks}

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