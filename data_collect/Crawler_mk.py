import requests
from pandas import DataFrame
from bs4 import BeautifulSoup
import re
from datetime import datetime
import os
import pdb
from time import sleep
import pandas as pd
import csv
class article:
    def __init__(self, title, author, time, article, paragraph,url,raw):
        self.title=title
        self.author=author
        self.create=time
        self.article=article
        self.paragraph=paragraph
        self.url=url
        self.raw=raw

    def display(self):
        print(self.title)
        print(self.summary)
        print(self.author)
        print(self.create)
        print(self.article)
        print(self.paragraph)
        print(self.url)

def Crawling(start):
    headers = {
    "User-Agent":
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36"
    }
    page=0
    news_list=[]
    art_list=[]
    for page in range(6,7):
        url="https://www.mk.co.kr/news/economy/?page="+str(page)
        r = requests.get(url, headers=headers)
        bs=BeautifulSoup(r.content,'html.parser')
        arr=bs.findAll("dt","tit")
        for i in arr:
            news_list.append(i.find('a')['href'])
    count=0
    for news in news_list:
        try:
            r = requests.get(news, headers=headers)
            r.encoding='utf-8'
            bs=BeautifulSoup(r.content,'html.parser')
            bs = BeautifulSoup(r.content.decode('euc-kr','replace'),'html.parser')
            temp=bs.find("div","art_txt")
            if temp.find("span"):
                if "연합뉴스" in temp.find("span").text:
                    continue
            title=bs.find("h1","top_title").text
            if '[표]' in title:
                continue
            if '[포토]' in title:
                continue
            if '[게시판]' in title:
                continue
            if '[외환]' in title:
                continue
            sum=bs.find("h2","sub_title1_new").findAll(text=True)
            kk=bs.find("div","art_txt").findAll(text=True)
            raw_art=kk[:-7]
            temp=[i for i in raw_art if "googletag" not in i]
            temp=''.join(temp)
            kk=[i for i in kk if i != '\n']
            kk.pop(0)
            kk=kk[:-4]
            result=""
            paragraph=[]
            for i in kk:
                if "googletag" not in i:
                    result+=i+" "
                    paragraph.append(i)
            summary=""
            for i in sum:
                summary+=(i+" ")
            author=bs.find("li","author")
            main_author=author.text
            time=bs.find("li","lasttime").text.split('\xa0')
            art=result
            try:
                fig=bs.findAll("figcaption")
                for i in fig:
                    art=art.replace(i.text,"")
                    for j in range(len(paragraph)):
                        paragraph[j] = paragraph[j].replace(i.text,"")
            except:
                pass
            if paragraph:
                news_idx=news.split("/")[-2]
                reporter=main_author.split()[0]
                time=time[0].split(":",1)[1].strip()
                f = '%Y.%m.%d %H:%M:%S'
                dt=datetime.strptime(time,f)
                art_list.append(article(title,reporter,dt,art,news_idx,news,temp))
                count+=1
        except Exception as e:
            pass
    data = pd.DataFrame([(i.title,i.author,i.create,i.article,i.paragraph,i.url,i.raw) for i in art_list ],columns=['Title','Reporter','Created','Body','News_Idx','Url','Raw'])
    return data

