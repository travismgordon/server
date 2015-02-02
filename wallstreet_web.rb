# => wallstreet.rb
# This is a basic stock info program,  it fetches data when fed a stock symbol.
# => It has been updated to ouput some data to the web.

# => required gems
require 'sinatra'
require 'httparty'
require 'nokogiri'

# => redefining the ticker symbol data fetcher as a method
def wallstreet(ticker)
	# => searching for ticker
	response = HTTParty.get('http://finance.yahoo.com/q?s=' + ticker)

	# => getting the data
	dom = Nokogiri::HTML(response.body)

	# => getting stock name
	span0 = dom.xpath('//*[@id="yfi_rt_quote_summary"]/div[1]/div/h2').first
	name = span0.content

	# => getting current price
	span1 = dom.xpath("//span[@id='yfs_l84_#{ticker.downcase}']").first
	price = span1.content

	# => getting previous day close
	span2 = dom.xpath("//td[@class='yfnc_tabledata1']").first
	previous = span2.content

	# => getting delta
	span3 = dom.xpath("//span[@id='yfs_c63_#{ticker.downcase}']").last
	change = span3.content.squeeze

	# => getting delta percentage
	span4 = dom.xpath("//*[@id='yfs_p43_#{ticker.downcase}']").first
	percent = span4.content

	# => getting opening price
	span5 = dom.xpath("//td[@class='yfnc_tabledata1']")[1]
	opening = span5.content

	# => output
	puts "Displaying infor for #{name}:\n\n"
	puts "The current price of #{ticker.upcase} is $#{price} per share.\n\n"
	puts "The previous closing price was $#{previous}.\n\n"
	puts "#{ticker.upcase} has changed by#{change} points #{percent}\nfrom today's opening price of $#{opening}.\n\n"
end

# => calling the method with some default values provided
puts "\n=========================================================\n"
wallstreet('aapl')
puts "\n=========================================================\n"
wallstreet('msft')
puts "\n=========================================================\n"
wallstreet('ibm')
puts "\n=========================================================\n"



# => end of file