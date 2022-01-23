import scrapy
class Pook(scrapy.Spider):
  name='pook'
  start_urls = ['https://www.imdb.com/chart/top']
  def parse(self, response):
    for blokk in response.css('.posterColumn'):
      yield {'Rating': blokk.css('*::attr("data-value")').getall()[1]}
      yield {'RNo': blokk.css('*::attr("data-value")').getall()[3]}
      yield {'title': blokk.css('*::attr("href")').get()}
      yield {'title': blokk.css('*::attr("alt")').get()}
      #if(blokk.css('*::attr("data-value")').get()=="20"): break
