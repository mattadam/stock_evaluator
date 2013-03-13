# To use:
# 1. visit finviz.com and select screener
# 2. under Industry select the industry you want and copy its url
# 3. set the value of url in method sector_tickers to your copied value

# Errors: undefined method text for nil means object
# at css can't be found. Use Selector Gadget to make sure
# the correct css marker is being used


# Determine Revenue / Market Cap 
# Scrape Finviz for ticker and price

require 'rubygems'
require 'nokogiri'
require 'open-uri'

def stock_retrieve(stock)

  url = "http://finviz.com/quote.ashx?t="+ stock
  doc = Nokogiri::HTML(open(url))
  ticker = doc.at_css(".fullview-ticker").text
  market_cap = doc.at_css(".table-dark-row:nth-child(2) :nth-child(2)").text
  income = doc.at_css(".table-dark-row:nth-child(3) :nth-child(2)").text
   	
  
  puts "#{ticker} #{market_cap}"
  puts market_ratio(market_cap, income)
 
end

# Calculate the ratio of market cap to income
# a value that shows how much a company could return to it's stock value
def market_ratio (market_cap, income)
  if market_cap.end_with?("M") and income.end_with?("M")
	  ratio = (income.to_f / market_cap.to_f).round(2)
	elsif market_cap.end_with?("B") and income.end_with?("B")
	  ratio = (income.to_f / market_cap.to_f).round(2)
	elsif market_cap.end_with?("B") and income.end_with?("M")
	  ratio = (income.to_f / (market_cap.to_f * 1000 )).round(2)
	elsif market_cap.end_with?("M") and income.end_with?("B")
	  ratio = ((income.to_f * 1000 )/ market_cap.to_f).round(2)
    end
end

# finds all tickers in sector
# need to change range of each loop for each sector
# change url for sector 
def sector_tickers
  url = "http://finviz.com/screener.ashx?v=111&f=ind_farmconstructionmachinery"
  doc = Nokogiri::HTML(open(url))
  stock_tickers = []
  total = doc.at_css(".count-text").text.split
  total = total[1].to_i + 5 						# find number of companies and add five to make sure all accounted for
  (1..total).each do |x|
    unless doc.at_css(":nth-child(#{x}) .tab-link").nil?
      unless doc.at_css(":nth-child(#{x}) .tab-link").text.length >= 5
	    stock_tickers << doc.at_css(":nth-child(#{x}) .tab-link").text
	  end
	end
	
	unless doc.at_css(".table-dark-row-cp:nth-child(#{x}) .tab-link").nil?
	  unless doc.at_css(".table-dark-row-cp:nth-child(#{x}) .tab-link").text.length >= 5
	    stock_tickers << doc.at_css(".table-dark-row-cp:nth-child(#{x}) .tab-link").text
	  end
	end
  end
  stock_tickers = stock_tickers.delete_if {|x| x == ""}  
  stock_tickers.uniq 
end

puts sector_tickers 

def sector_ratios
  array = sector_tickers
  array.each do |x|
    stock_retrieve(x)
  end
end

sector_ratios


