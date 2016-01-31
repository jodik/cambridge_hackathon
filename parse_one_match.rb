require 'open-uri'
require 'nokogiri'
require 'csv'
require 'andand'

url = "http://www.hockey-reference.com/boxscores/201511150CHI.html"
source = open(url).read

nokogiri = Nokogiri::HTML(source)

# Read all tables that are of 'sortable  stats_table' class
tables = nokogiri.css("#box [class='sortable  stats_table']")

rows_skater = tables[0].css("tbody tr")
rows_goalie = tables[1].css("tbody tr")

csv_string = CSV.generate do |csv|

  rows_goalie.each do |row|
    csv << [
      row.css("td:nth-child(2) a").text,
      "G",
      row.css("td:nth-child(4)").text,
      row.css("td:nth-child(5)").text,
      row.css("td:nth-child(10)").text
    ]
  end

  csv << []

  rows_skater.each do |row|
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

  csv << []

  rows_skater = tables[2].css("tbody tr")
  rows_goalie = tables[3].css("tbody tr")      

  rows_goalie.each do |row_goalie|
    csv << [
      row_goalie.css("td:nth-child(2) a").text,
      "G",
      row_goalie.css("td:nth-child(4)").text,
      row_goalie.css("td:nth-child(5)").text,
      row_goalie.css("td:nth-child(10)").text
    ]
  end

  csv << []

  rows_skater.each do |row_skater|
    url_sub = "http://www.hockey-reference.com" + row_skater.css("td:nth-child(2) a").attr("href")
    source_sub = open(url_sub).read

    nokogiri_sub = Nokogiri::HTML(source_sub)
    
    position = nokogiri_sub.css(".float_left.margin_left div:last-child p:nth-child(2)").children[1].andand.text.andand.gsub(/\W+/, '')
    if position.nil?
      position = nokogiri_sub.css(".float_left.margin_left div:last-child p:first-child").children[1].andand.text.andand.gsub(/\W+/, '')
    end
    
    csv << [
      row_skater.css("td:nth-child(2) a").text,
      position,
      row_skater.css("td:nth-child(3)").text,
      row_skater.css("td:nth-child(4)").text,
      row_skater.css("td:nth-child(6)").text,
      row_skater.css("td:nth-child(15)").text,
      row_skater.css("td:nth-child(18)").text
    ]
  end

  csv << []

end

puts csv_string
