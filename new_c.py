import requests
from pandas import DataFrame
import pandas as pd
from bs4 import BeautifulSoup
import re
from datetime import datetime
import os
import pdb
from time import sleep
headers = {
"User-Agent":
"Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36"
}
class Article:
    def __init__(self, title, pubdate, keyword,main,link):
        self.title=title
        self.main=main
        self.keyword=keyword
        self.pubDate=pubdate
        self.link=link
class Url:
    def __init__(self,keyword,link):
        self.keyword=keyword
        self.link=link
payload = {'param1': '1', 'param2': '2'}
article_num=4988538
cnt=0
title_list=[]
time_list=[]
summary_list=[]
main_list=[]
url_list=[]
news_list=[]
article_list=[]
import csv
f = open('C:\\Users\\SeoHyeongSeoksCOM\\Desktop\\result.csv', 'r', encoding='utf-8-sig')
rdr = csv.reader(f)
for line in rdr:
    if 'naver' in line[5]:
        news_list.append(Url(line[2],line[5]))
f.close()
temp=""
for i in news_list:
    if cnt >400:
        if i.keyword==temp:
            continue
        else:
            cnt=0
    r = requests.get(i.link, params=payload, headers=headers)
    bs = BeautifulSoup(r.content,"html.parser")
    article=bs.find("div",{"class":"newsct_article _article_body"})
    try:
        main=article.text
        article_title=bs.find("h2")
        article_time=bs.find("span","media_end_head_info_datestamp_time _ARTICLE_DATE_TIME")
        article_summary=bs.find("div","go_trans _article_content")
        article_img=bs.findAll("em","img_desc")
        for j in article_img:
            main=main.replace(j.text,"")
        title=article_title.text
        time=article_time.text
        article_list.append(Article(title,time,i.keyword,main,i.link))
        cnt+=1
        temp=i.keyword
    except:
        continue
data = pd.DataFrame([(i.title,i.main,i.keyword) for i in article_list ],columns=['제목','설명','키워드'])
data.to_csv('C:\\Users\\SeoHyeongSeoksCOM\\Desktop\\result3.csv',encoding="utf-8-sig",index=False)
