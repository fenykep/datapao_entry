import scrapy
from scrapy.crawler import CrawlerProcess

movies=[]

class IMDbSpider(scrapy.Spider):
	custom_settings = {
		'COOKIES_ENABLED': False,
	}

	name='imdb_spider'
	start_urls = ['https://www.imdb.com/chart/top']
	
	#Parse the details of the titles that we want to scrape
	def parse(self, response):
		for titleBlock in response.css('.posterColumn'):
			if(titleBlock.css('*::attr("data-value")').getall()[0]!="21"):
				scraped_info = {
					'index' : titleBlock.css('*::attr("data-value")').getall()[0],
					'rating' : titleBlock.css('*::attr("data-value")').getall()[1],
					'ratingNo' : titleBlock.css('*::attr("data-value")').getall()[3],
					'ID' : titleBlock.css('*::attr("href")').get().split('/')[2],
					'title' : titleBlock.css('*::attr("alt")').get(),
					'oscarNo' : 0,
					'adjRating' : 0,
				}

				#check if the variables that we will be using are actually numbers
				try:
					assert scraped_info['index'].isdigit()
					assert scraped_info['rating'].replace('.','').isdigit()
					assert scraped_info['ratingNo'].isdigit()
					assert scraped_info['ID'].lstrip('t').isdigit()
				except:
					print("index: "+scraped_info['index']+"\n rating: "+scraped_info['rating']+"\n RNo: "+scraped_info['ratingNo']+"\n ID: "+scraped_info['ID']+"\n")
					raise Source_Error('There is an issue with the incoming data')
				else:
					scraped_info['index'] = int(scraped_info['index'])
					scraped_info['rating'] = float(scraped_info['rating'])
					scraped_info['ratingNo'] = int(scraped_info['ratingNo'])
					movies.append(scraped_info)

					#Parse each movie's page where the awards can be found 
					newurl = 'https://www.imdb.com/title/' + scraped_info['ID']
					yield scrapy.Request(newurl, callback=self.get_oscars, meta={'index': scraped_info['index']}, dont_filter=True)
			else:
				break

	#Parse the number of oscars a film got
	def get_oscars(self, response):
		index = response.meta.get('index')
		oscarNo = response.xpath('/html/body/div[2]/main/div/section[1]/div/section/div/div[1]/section[1]/div/ul/li/a[1]/text()').get().split()
		if oscarNo[0]=="Won":
			movies[index]['oscarNo']=int(oscarNo[1])

#Find the most ratings a film ever got
def find_maxRatingNo():
	maxRatingNo=0
	for movie in movies:
		if movie['ratingNo'] > maxRatingNo:
			maxRatingNo=movie['ratingNo']
	return maxRatingNo

#Calculate the new rating based on number of oscars and number of ratings
def adjust_rating():
	maxRatingNo=find_maxRatingNo()
	for movie in movies:
		movie['adjRating'] = movie['rating']-int((maxRatingNo-movie['ratingNo'])/100000)*0.1
		if(1<=movie['oscarNo']<=2): 
			movie['adjRating']+=0.3
		elif(3<=movie['oscarNo']<=5): 
			movie['adjRating']+=0.5
		elif(6<=movie['oscarNo']<=10): 
			movie['adjRating']+=1.0
		elif(10<movie['oscarNo']): 
			movie['adjRating']+=1.5

def writeToDB():
	database = open("IMDb_TOP20_Adjusted.csv", "w")
	database.write("TITLE;ID;IMDb SCORE;RATING NO;OSCAR NO;AJDUSTED SCORE\n")
	for movie in movies:
		database.write(movie['title']+";"+movie['ID']+";"+str(movie['rating'])+";"+str(movie['ratingNo'])+";"+str(movie['oscarNo'])+";"+str(movie['adjRating'])+"\n")
	database.close()

process = CrawlerProcess(settings={

})

process.crawl(IMDbSpider)
process.start()

adjust_rating()
writeToDB()
