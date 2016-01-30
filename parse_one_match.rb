require 'open-uri'
require 'nokogiri'
require 'csv'
require 'andand'

url = "http://www.hockey-reference.com/boxscores/201511150CHI.html"
source = open(url).read

nokogiri = Nokogiri::HTML(source)

rows = nokogiri.css("#CGY_skaters tbody tr")

csv_string = CSV.generate do |csv|
  rows.each do |row|

    url_sub = "http://www.hockey-reference.com" + row.css("td:nth-child(2) a").attr("href")
    source_sub = open(url_sub).read

    nokogiri_sub = Nokogiri::HTML(source_sub)
    
    position = nokogiri_sub.css(".float_left.margin_left div:last-child p:nth-child(2)").children[1].andand.text.andand.gsub(/\W+/, '')
    if position.nil?
      position = nokogiri_sub.css(".float_left.margin_left div:last-child p:first-child").children[1].andand.text.andand.gsub(/\W+/, '')
    end
    
    csv << [
      row.css("td:nth-child(2) a").text,
      position,
      row.css("td:nth-child(3)").text,
      row.css("td:nth-child(4)").text,
      row.css("td:nth-child(6)").text,
      row.css("td:nth-child(15)").text,
      row.css("td:nth-child(18)").text
    ]
  end
end

puts csv_string
