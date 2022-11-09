import os
import pickle
import json

class Config:
    SAMPLE_NEWS_DATA_PATH = "/ToT/news_process/data/news_data_mg.csv"
    DF_DATA_PATH = "/ToT/news_process/data/df_"
    STOCK_LIST_PATH = "/data/stock_list.csv"
    SUBSTITUTE_DATA_PATH = "/ToT/news_process/data/keyword_substitutes.json"

config = Config()

def load_substitute_data():
    try:
        with open(config.SUBSTITUTE_DATA_PATH, 'r', encoding="UTF-8") as json_f:
            data = json.load(json_f)
    except FileNotFoundError:
        data = None

    return data

def load_df_data():
    try:
        with open(config.DF_DATA_PATH, 'rb') as fp:
            data = pickle.load(fp)
    except FileNotFoundError:
        data = None

    return data

def update_df_data(data):
    with open(config.DF_DATA_PATH, 'wb') as fp:
        pickle.dump(data, fp)