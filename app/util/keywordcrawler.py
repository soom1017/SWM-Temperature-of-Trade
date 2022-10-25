import requests
from bs4 import BeautifulSoup
from collections import deque
import json

headers = {
        "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36"
}
year="2022"
url="https://data.kostat.go.kr/social/getMonthDayList.do?startyear=2022&endyear=2022"
      
class MapCrawler:  
    dates = deque([])
    def __init__(self):
        res = requests.get(url, headers=headers)
        bs = BeautifulSoup(res.content, 'html.parser')
        js = json.loads(bs.text)
        for i in range(1, 5):
            from_date = year + js["startMMDD"][-i]["mm"] + js["startMMDD"][-i]["dd"]
            to_date = year + js["endMMDD"][-i]["mm"] + js["endMMDD"][-i]["dd"]
            self.dates.append((from_date, to_date))

    def get_map_data(self, keyword: str):
        if not self.dates:
            return None
        from_date, to_date = self.dates.popleft()

        network_url=f"https://data.kostat.go.kr/social/getNetworkList.do?fromdate={from_date}&todate={to_date}&categoryCd=ECO_KWD&word={keyword}&termDicCd=1"
        res = requests.get(network_url, headers=headers)
        bs = BeautifulSoup(res.content, 'html.parser')
        js = json.loads(bs.text)
        if not js["dataList"]:
            return self.get_map_data(keyword)
        
        data = {
            "keyword_list": [keyword],
            "graph": {
                keyword: [],
            }
        }
        for i, key in enumerate(js["dataList"]):
            relateWrd = key["relateWrd"]
            upperRelateWrd = key["upperRelateWrd"]
            if i % 3 == 0:
                data["keyword_list"].append(relateWrd)
                data["graph"][keyword].append(relateWrd)
                data["graph"][relateWrd] = []
            data["keyword_list"].append(upperRelateWrd)
            data["graph"][relateWrd].append(upperRelateWrd)
                
        return data

