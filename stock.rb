#Scrape Finviz for ticker and price

require 'rubygems'
require 'nokogiri'
require 'open-uri'

def stock_retrieve(stock)

  url = "http://finviz.com/quote.ashx?t="+ stock
  doc = Nokogiri::HTML(open(url))
  ticker = doc.at_css(".fullview-ticker").text
  price = doc.at_css(":nth-child(11) :nth-child(12)").text.to_f
  price_to_book = doc.at_css(":nth-child(5) :nth-child(4)").text.to_f
  debt_to_equity = doc.at_css(":nth-child(10) :nth-child(4)").text.to_f 
  eps_this_year = doc.at_css(":nth-child(4) .snapshot-td2:nth-child(6) span").text.to_f 
  eps_next_year = doc.at_css(":nth-child(5) :nth-child(6)").text.to_f 
  current_ratio = doc.at_css(":nth-child(9) :nth-child(4)").text.to_f
  insider_trans = doc.at_css(".table-dark-row:nth-child(2) :nth-child(8) b").text.to_f 
  gross_margin = doc.at_css(":nth-child(8) :nth-child(8)").text.to_f 
  
  puts "#{ticker} #{price}"
  puts "P/B = #{price_to_book}"
  puts "D/E = #{debt_to_equity}"
  puts "EPS this year = #{eps_this_year}%"
  puts "EPS next year = #{eps_next_year}%"
  puts "Current Ratio = #{current_ratio}"
  puts "Insider transaction = #{insider_trans}%"
  puts "Gross Margin = #{gross_margin}%"
  puts valuation(price_to_book, debt_to_equity, eps_this_year, eps_next_year, current_ratio,insider_trans, gross_margin)
  
end

def valuation(price_to_book, debt_to_equity, eps_this_year, eps_next_year, current_ratio,insider_trans, gross_margin)
  sum = 0
  if price_to_book >= 1 then sum -= 1 else sum += 1 end
  if debt_to_equity >= 30 then sum -= 1 else sum += 1 end
  if eps_this_year < 0 then sum -= 1 else sum += 1 end
  if eps_next_year < 0 then sum -= 1 else sum += 1 end
  if current_ratio < 1.5 then sum -= 1 else sum += 1 end
  if insider_trans < 0 then sum -= 1 else sum += 1 end
  if gross_margin < 50 then sum -= 1 else sum += 1 end
  if sum > 0 then return "undervalued" else return "overvalued" end 
end

stock_retrieve("mind")