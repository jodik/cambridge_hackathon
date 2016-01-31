require 'open-uri'
require 'nokogiri'
require 'csv'
require 'andand'
require 'parallel'

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

  csv_string = CSV.generate(:col_sep => " ") do |csv|
    rows.each do |row|
      url_match = "http://www.hockey-reference.com" + row.css("td:first-child a").attr("href")
      csv << [
        (row_number += 1),
        url_match,
        row.css("td:first-child a").text,
        row.css("td:nth-child(2) a").text,
        row.css("td:nth-child(4) a").text,
        row.css("td:nth-child(3)").text,
        row.css("td:nth-child(5)").text
      ]

      source_match = open(url_match).read

      nokogiri = Nokogiri::HTML(source_match)

      # Read all tables that are of 'sortable  stats_table' class
      tables = nokogiri.css("#box [class='sortable  stats_table']")

      rows_skater = tables[0].css("tbody tr")
      rows_goalie = tables[1].css("tbody tr")      

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
  end

  puts csv_string
end