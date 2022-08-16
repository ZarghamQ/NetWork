import requests, json
 
def topNews():
    query_params = {
      "source": "bbc-news",
      "sortBy": "top",
      "apiKey": "43f31dd71aa249d1a6d2b8fc3bd23aaf"
    }
    main_url = " https://newsapi.org/v1/articles"
 
    # fetching data in json format
    res = requests.get(main_url, params=query_params)
    open_bbc_page = res.json()
 
    # getting all articles in a string article
    article = open_bbc_page["articles"]
 
    # empty list which will
    # contain all trending news
     
    for ar in article:
        title = ar['title']
        description = ar['description']
        url = ar['url']
        image = ar['urlToImage'],
        news = {
            'Title' : title,
            'Description' : description,
            'Photo_url' : image[0],
            'Url' : url,
        }
        results.append(news)
    return

results = []
            
# topNews()
# print(json.dumps(results, indent=2))