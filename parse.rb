require 'open-uri'
require 'nokogiri'
require 'csv'

dates = (Date.parse('2014-10-08')..Date.parse('2015-06-15')).to_a.map { |date| date.strftime('%Y/%-m/%-d') }

row_number = 0

dates.each do |date|
  url = "http://www.hockey-reference.com/boxscores/#{date}"
  source = open(url).read

  nokogiri = Nokogiri::HTML(source)

  rows = nokogiri.css("#stats tbody tr")

  if rows.size == 0
    next
  end

  csv_string = CSV.generate do |csv|
    rows.each do |row|
      csv << [
        (row_number += 1),
        "http://www.hockey-reference.com" + row.css("td:first-child a").attr("href"),
        row.css("td:first-child a").text,
        row.css("td:nth-child(2) a").text,
        row.css("td:nth-child(4) a").text,
        row.css("td:nth-child(3)").text,
        row.css("td:nth-child(5)").text
      ]
    end
  end

  puts csv_string
end