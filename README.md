A simple webscraper written in python3 using the scrapy library.

To use you need to have scrapy downloaded. [pip install scrapy]
After that just run [python imdb_spider.py] and it will yield a semicolon-separated database with the adjusted IMDb ratings according to this formula:
-Every 100k deviation in the number of user ratings from the most rated film reduces the film's score by 0.1
-1 or 2 oscars adds 0.3 points to the score
-3 to 5 oscars adds 0.5
-6 to 10 oscars adds 1.0
-10+ oscar awards adds 1.5

Possible improvements:
-use more internal scrapy functions and datatypes
-handle single datapoint errors but keep fetching
