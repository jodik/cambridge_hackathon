# import kron
import lxml
import sys
import kron
import scrapy

class StackOverflowSpider(scrapy.Spider):
    name = 'stackoverflow'
    start_urls = ['http://www.hockey-reference.com/boxscores/2014/10/8/']

    def parse(self, response):
        for href in response.css('.sortable tbody tr'):
            print href.extract()
            #full_url = response.urljoin(href.extract())
            #yield scrapy.Request(full_url, callback=self.parse_question)

    def parse_question(self, response):
        yield {
            'title': response.css('h1 a::text').extract()[0],
            'votes': response.css('.question .vote-count-post::text').extract()[0],
            'body': response.css('.question .post-text').extract()[0],
            'tags': response.css('.question .post-tag::text').extract(),
            'link': response.url,
        }

def getHotelsInfo():
    url = 'http://www.booking.com/searchresults.cs.html?label=gen173nr-15CAEoggJCAlhYSDNiBW5vcmVmaDqIAQGYATG4AQTIAQTYAQPoAQH4AQI;sid=1158002d03c45d61831fa469b8ab49c8;dcid=4;checkin_monthday=22&checkin_year_month=2015-11&checkout_monthday=23&checkout_year_month=2015-11&class_interval=1&csflt=%7B%7D&dest_id=-542184&dest_type=city&group_adults=2&group_children=0&label_click=undef&no_rooms=1&offset=0&offset_unavail=1&review_score_group=empty&room1=A%2CA&sb_price_type=total&score_min=0&si=ai%2Cco%2Cci%2Cre%2Cdi&src=index&ss=Brno%2C%20South%20Moravia%2C%20Czech%20Republic&ss_raw=Brno&ssb=empty&'
           #http://www.booking.com/searchresults.cs.html?label=gen173nr-15CAEoggJCAlhYSDNiBW5vcmVmaDqIAQGYATG4AQTIAQTYAQPoAQH4AQI&sid=1158002d03c45d61831fa469b8ab49c8&dcid=4&checkin_monthday=22&checkin_year_month=2015-11&checkout_monthday=23&checkout_year_month=2015-11&class_interval=1&csflt=%7B%7D&dest_id=-542184&dest_type=city&group_adults=2&group_children=0&label_click=undef&no_rooms=1&offset_unavail=1&review_score_group=empty&room1=A%2CA&sb_price_type=total&score_min=0&si=ai%2Cco%2Cci%2Cre%2Cdi&src=index&ss=Brno%2C%20South%20Moravia%2C%20Czech%20Republic&ss_raw=Brno&ssb=empty&nflt=class%3D3%3B
        #http://www.booking.com/searchresults.cs.html?label=gen173nr-15CAEoggJCAlhYSDNiBW5vcmVmaDqIAQGYATG4AQTIAQTYAQPoAQH4AQI&sid=1158002d03c45d61831fa469b8ab49c8&dcid=4&checkin_monthday=22&checkin_year_month=2015-11&checkout_monthday=23&checkout_year_month=2015-11&class_interval=1&csflt=%7B%7D&dest_id=-542184&dest_type=city&group_adults=2&group_children=0&label_click=undef&no_rooms=1&offset_unavail=1&review_score_group=empty&room1=A%2CA&sb_price_type=total&score_min=0&si=ai%2Cco%2Cci%2Cre%2Cdi&src=index&ss=Brno%2C%20South%20Moravia%2C%20Czech%20Republic&ss_raw=Brno&ssb=empty&nflt=class%3D3%3Bclass%3D4%3B
        #http://www.booking.com/searchresults.cs.html?label=gen173nr-15CAEoggJCAlhYSDNiBW5vcmVmaDqIAQGYATG4AQTIAQTYAQPoAQH4AQI&sid=1158002d03c45d61831fa469b8ab49c8&dcid=4&checkin_monthday=22&checkin_year_month=2015-11&checkout_monthday=23&checkout_year_month=2015-11&class_interval=1&csflt=%7B%7D&dest_id=-542184&dest_type=city&group_adults=2&group_children=0&label_click=undef&no_rooms=1&offset_unavail=1&review_score_group=empty&room1=A%2CA&sb_price_type=total&score_min=0&si=ai%2Cco%2Cci%2Cre%2Cdi&src=index&ss=Brno%2C%20South%20Moravia%2C%20Czech%20Republic&ss_raw=Brno&ssb=empty&nflt=class%3D3%3Bclass%3D4%3Bht_id%3D204%3B
        #http://www.booking.com/searchresults.cs.html?label=gen173nr-15CAEoggJCAlhYSDNiBW5vcmVmaDqIAQGYATG4AQTIAQTYAQPoAQH4AQI&sid=1158002d03c45d61831fa469b8ab49c8&dcid=1&checkin_monthday=22&checkin_year_month=2015-11&checkout_monthday=23&checkout_year_month=2015-11&class_interval=1&csflt=%7B%7D&dest_id=-542184&dest_type=city&dtdisc=0&group_adults=2&group_children=0&hlrd=0&hyb_red=0&inac=0&label_click=undef&nflt=class%3D3%3Bclass%3D4%3Bht_id%3D204%3B&nha_red=0&no_rooms=1&redirected_from_city=0&redirected_from_landmark=0&redirected_from_region=0&review_score_group=empty&room1=A%2CA&sb_price_type=total&score_min=0&si=ai%2Cco%2Cci%2Cre%2Cdi&ss=Brno%2C%20South%20Moravia%2C%20Czech%20Republic&ss_all=0&ss_raw=Brno&ssb=empty&sshis=0&order=price_for_two
        #http://www.booking.com/searchresults.cs.html?label=gen173nr-15CAEoggJCAlhYSDNiBW5vcmVmaDqIAQGYATG4AQTIAQTYAQPoAQH4AQI&sid=1158002d03c45d61831fa469b8ab49c8&dcid=1&checkin_monthday=22&checkin_year_month=2015-11&checkout_monthday=23&checkout_year_month=2015-11&class_interval=1&csflt=%7B%7D&dest_id=-542184&dest_type=city&dtdisc=0&group_adults=2&group_children=0&hlrd=0&hyb_red=0&inac=0&label_click=undef&nflt=class%3D3%3Bclass%3D4%3Bht_id%3D204%3B&nha_red=0&no_rooms=1&redirected_from_city=0&redirected_from_landmark=0&redirected_from_region=0&review_score_group=empty&room1=A%2CA&sb_price_type=total&score_min=0&si=ai%2Cco%2Cci%2Cre%2Cdi&ss=Brno%2C%20South%20Moravia%2C%20Czech%20Republic&ss_all=0&ss_raw=Brno&ssb=empty&sshis=0&order=price_for_two
    # url = 'http://www.booking.com/hotel/cz/old-town.html?label=gen173nr-15CAEoggJCAlhYSDNiBW5vcmVmaDqIAQGYATG4AQTIAQTYAQPoAQH4AQI;sid=61e41e9d9ae4fbfe4033807aa7ed8a85;dcid=1;checkin=2015-11-21;checkout=2015-11-22;dist=0;group_adults=2;no_rooms=1;room1=A%2CA;sb_price_type=total;srfid=4e6c459bf5e35d664dafbf20cb5a30e609ce9e95X3;type=total;ucfs=1&;selected_currency=CZK;changed_currency=1'
    event = {'checkinday': '22', 'checkin_month_and_year': '2015-11', 'checkoutday': '23', 'checkout_month_and_year': '2015-11', 'dest_id' : '-542184', 'adults': '2', 'offset': '0'}
    prices = kron.scrape(event, "s")
    print prices
    # print kron.scrape(url)
    
if __name__ == "__main__":
    getHotelsInfo()
