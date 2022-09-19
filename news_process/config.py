import os

class Config:
    SAMPLE_NEWS_DATA_PATH = f"{os.path.dirname(os.path.realpath(__file__))}/data/news_data_mg.csv"
    DF_SAVED_PATH = f"{os.path.dirname(os.path.realpath(__file__))}/data/df_"
    
config = Config()