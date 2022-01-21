require 'nokogiri'
require 'httparty'

def scraper
	url='https://www.imdb.com/chart/top'
	unparsed = HTTParty.get(url)
	parsed = Nokogiri::HTML(unparsed)
	for blokk in parsed.css('td.posterColumn') do
		print blokk.children[3].attribute("data-value")
		print ";"
		print blokk.children[7].attribute("data-value")
		print ";"
		print blokk.css('a').attribute("href")
		print ";"
		print blokk.css('img').attribute("alt")
		print "\n"
	end
end

def gyors
	url='https://www.imdb.com/chart/top'
	unparsed = HTTParty.get(url)
	reader = Nokogiri::XML::Reader(unparsed)
	print reader	
	reader.each do |node|
		print node
	end
end

scraper

