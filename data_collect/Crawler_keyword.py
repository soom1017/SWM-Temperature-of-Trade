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
import json
class Keyword:
    def __init__(self,from_date,to_date, key,frequency):
        self.from_date=from_date
        self.to_date=to_date
        self.key=key
        self.frequency=frequency

    def display(self):
        print("from: ",self.from_date)
        print("to: ",self.to_date)
        print("key: ",self.key)
        print("frequency: ",self.frequency)
class FromDate:
    def __init__(self, from_m, from_d):
        self.from_m=from_m
        self.from_d=from_d
        self.md=from_m+from_d
    def display(self):
        print("md: ",self.md)
class ToDate:
    def __init__(self, to_m, to_d):
        self.to_m=to_m
        self.to_d=to_d
        self.md=to_m+to_d
    def display(self):
        print("md: ",self.md)
class KeyList:
    def __init__(self, from_date, to_date,key):
        self.from_date=from_date
        self.to_date=to_date
        self.key=key
class KeyNetwork:
    def __init__(self, wrd,relateWrd,relateCn,relateCnt,upperRelateWrd,brnk,secRelateCnt,secPer, from_date, to_date):
        self.wrd = wrd
        self.relateWrd = relateWrd
        self.relateCn = relateCn
        self.relateCnt = relateCnt
        self.upperRelateWrd = upperRelateWrd
        self.brnk = brnk
        self.secRelateCnt = secRelateCnt
        self.secPer = secPer
        self.from_date=from_date
        self.to_date= to_date

headers = {
"User-Agent":
"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36"
}
year='2022'
start_url="https://data.kostat.go.kr/social/getMonthDayList.do?chkStr=fromdate&startyear=2022&endyear=2022"
end_url="https://data.kostat.go.kr/social/getMonthDayList.do?chkStr=todate&startyear=2022&endyear=2022"
from_list=[]
to_list=[]
data_list=[]
temp_list=['카카오뱅크','카카오게임즈','카카오톡','카카오페이']
r = requests.get(start_url, headers=headers)
bs=BeautifulSoup(r.content,'html.parser')
js=json.loads(bs.text)
for i in js['startMMDD']:
    from_list.append(FromDate(i['mm'],i['dd']))
r = requests.get(end_url, headers=headers)
bs=BeautifulSoup(r.content,'html.parser')
js=json.loads(bs.text)
for i in js['endMMDD']:
    to_list.append(ToDate(i['mm'],i['dd']))
to_list.pop(0)
count=1
temp=[]
from_list=from_list[-4:]
to_list=to_list[-4:]
################# Get Keywork_List ###############
for i in range(len(from_list)):
    key_list=[]
    from_date=year+from_list[i].md
    to_date=year+to_list[i].md
    url="https://data.kostat.go.kr/social/getPointKeywordList.do?fromdate="+from_date+"&todate="+to_date+"&categoryCd=ECO_KWD&termDicCd=1"
    r = requests.get(url, headers=headers)
    bs=BeautifulSoup(r.content,'html.parser')
    js=json.loads(bs.text)
    for i in js['dataList']:
        key_list.append(Keyword(from_date,to_date,i['text'],i['frequency']))
    for i in temp_list:
        temp.append(KeyList(from_date,to_date,Keyword(from_date,to_date,i,0)))
    data = pd.DataFrame([(i.key,i.frequency) for i in key_list ],columns=['name','views'])
    data.to_csv('/data'+from_date+"_"+to_date+'_key.csv',encoding="utf-8-sig",index=False)
######## Get Network_List #####################
network_list=[]
for key_list in temp:
    key=key_list.key
    keynetwork_list=[]
    network_url="https://data.kostat.go.kr/social/getNetworkList.do?fromdate="+key.from_date+"&todate="+key.to_date+"&categoryCd=ECO_KWD&word="+key.key+"&termDicCd=1"
    r = requests.get(network_url, headers=headers)
    bs=BeautifulSoup(r.content,'html.parser')
    js=json.loads(bs.text)
    for i in js['dataList']:
        keynetwork_list.append(KeyNetwork(i['wrd'],i['relateWrd'],i['relateCn'],i['relateCnt'],i['upperRelateWrd'],i['brnk'],i['secRelateCnt'],i['secPer'],key.from_date,key.to_date))
        network_list.append(KeyNetwork(i['wrd'],i['relateWrd'],i['relateCn'],i['relateCnt'],i['upperRelateWrd'],i['brnk'],i['secRelateCnt'],i['secPer'],key.from_date,key.to_date))
    data = pd.DataFrame([(i.wrd, i.relateWrd, i.relateCn, i.relateCnt, i.upperRelateWrd, i.brnk, i.secRelateCnt, i.secPer) for i in keynetwork_list ],columns=['wrd','relateWrd','relateCn','relateCnt', 'upperRelateWrd', 'brnk', 'secRelateCnt', 'secPer'])
    data.to_csv('/data'+key_list.from_date+'_'+key_list.to_date+'_network.csv',encoding="utf-8-sig",index=False)
##

