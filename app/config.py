import os
from dotenv import load_dotenv

# load .env
load_dotenv()

class Settings:
    	
    DB_USERNAME : str = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWD")
    DB_HOST : str = os.getenv("DB_HOST","localhost")
    DB_PORT : str = os.getenv("DB_PORT",3306)
    DB_NAME : str = os.getenv("DB_NAME")
	
    DATABASE_URL = f"mysql+pymysql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}?charset=utf8"
    
    HOT_NEWSLIST_PATH: str = os.getenv("HOT_NEWSLIST_PATH")
    HOT_KEYWORD_PATH: str = os.getenv("HOT_KEYWORD_PATH")
    KEYWORD_LIST_PATH: str = os.getenv("KEYWORD_LIST_PATH")
    SENTIMENT_STATS_PATH: str = os.getenv("SENTIMENT_STATS_PATH")
    
class OauthSettings:
    FIREBASE_CERT_PATH: str = os.getenv("FIREBASE_CERT_PATH")

settings = Settings()
oauthsettings = OauthSettings()