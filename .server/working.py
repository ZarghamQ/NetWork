import requests, json
from bs4 import BeautifulSoup

def extract(position, location, page):
    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36'}
    url = f'https://www.indeed.com/jobs?q={position}&l={location}&start={page}'
    r = requests.get(url, headers)
    soup = BeautifulSoup(r.content, 'html.parser')
    return soup

def transform(soup):
    job_title = soup.find_all('a', class_="tapItem")
    for item in job_title:
        title = item.find('h2').get_text()
        url = 'https://www.indeed.com' + item['href']
        title = item.find('h2').get_text()
        company = item.find('span', class_='companyName').get_text()
        location = item.find('div', class_='companyLocation').get_text()

        try:
            salary = item.find('div', class_='heading6 tapItem-gutter metadataContainer').get_text()
        except:
            salary = 'none'
       
        job = {         
            'Title': title,
            'Company': company,
            'Location': location,
            'Salary': salary,
            'Url': url,
        }
        jobList.append(job)
    return
    
    
jobList = []

# for testing
# a = extract('swe', 'nyc', 0)
# transform(a)
# data = json.dumps(jobList, indent = 2)
# print(data)

    