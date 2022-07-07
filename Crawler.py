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
payload = {'param1': '1', 'param2': '2'}
article_num=4988538
url="https://n.news.naver.com/mnews/article/009/000"+str(article_num)+"?sid=101"
r = requests.get(url, params=payload, headers=headers)
cnt=0
title_list=[]
time_list=[]
summary_list=[]
main_list=[]
url_list=[]
while r.status_code == 200:
    try:
        # bs = BeautifulSoup(r.content,"html.parser")
        # article=bs.find("div",{"class":"newsct_article _article_body"})
        # main=article.text
        # article_title=bs.find("h2")
        # article_time=bs.find("span","media_end_head_info_datestamp_time _ARTICLE_DATE_TIME")
        # article_summary=bs.find("div","go_trans _article_content")
        # article_img=bs.findAll("em","img_desc")
        # for i in article_img:
        #     main=main.replace(i.text)
        # print("제목: ", article_title.text)
        # print("기사작성 시간:", article_time.text)
        # print("기자요약: ",article_summary.span.text)
        # print("본문: ",main)
        # a=article_summary.span.text.split('\n')
        # print(a[0])
        # pdb.set_trace()
        article_num+=1
        url="https://n.news.naver.com/mnews/article/009/000"+str(article_num)+"?sid=101"
        r = requests.get(url, params=payload, headers=headers)
    except:
        article_num+=1
        url="https://n.news.naver.com/mnews/article/009/000"+str(article_num)+"?sid=101"
        r = requests.get(url, params=payload, headers=headers)
        continue
article_num-=1
url="https://n.news.naver.com/mnews/article/009/000"+str(article_num)+"?sid=101"
r = requests.get(url, params=payload, headers=headers)
while r.status_code == 200:
    if cnt==1000:
        break
    try:
        bs = BeautifulSoup(r.content,"html.parser")
        article=bs.find("div",{"class":"newsct_article _article_body"})
        main=article.text
        article_title=bs.find("h2")
        article_time=bs.find("span","media_end_head_info_datestamp_time _ARTICLE_DATE_TIME")
        article_summary=bs.find("div","go_trans _article_content")
        article_img=bs.findAll("em","img_desc")
        a=article_summary.span.text.split('\n')
        article_summary=a[0]
        for i in article_img:
            main=main.replace(i.text)
        print("제목: ", article_title.text)
        print("기사작성 시간:", article_time.text)
        print("기자요약: ",article_summary)
        print("본문: ",main)
        title_list.append(article_title.text)
        time_list.append(article_time.text)
        summary_list.append(article_summary)
        main_list.append(main)
        url_list.append(url)
        cnt+=1
        article_num-=1
        url="https://n.news.naver.com/mnews/article/009/000"+str(article_num)+"?sid=101"
        r = requests.get(url, params=payload, headers=headers)
    except:
        article_num-=1
        url="https://n.news.naver.com/mnews/article/009/000"+str(article_num)+"?sid=101"
        r = requests.get(url, params=payload, headers=headers)
        continue
df=pd.DataFrame(list(zip(title_list,time_list,summary_list,main_list,url_list)), columns = ['제목', '기사 작성 시간', '기사 요약', '본문','기사 링크'])
# df=pd.DataFrame('제목':title_list,
#                 '기사 작성 시간':time_list,
#                 '기사 요약':summary_list,
#                 '본문':main_list)
df.to_csv("C:\\Users\\SeoHyeongSeoksCOM\\Desktop\\data.csv",encoding="utf-8-sig")
