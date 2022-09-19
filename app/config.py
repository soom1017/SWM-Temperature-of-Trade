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
    
class OauthSettings:
    KAKAO_REST_API_KEY : str = os.getenv("REST_API_KEY")
    KAKAO_REDIRECT_URI : str = os.getenv("REDIRECT_URI")

settings = Settings()
oauthsettings = OauthSettings()