require 'rss'
require 'open-uri'
require 'rexml/document'

#format
# 2013-07-25
# ==========
# 날씨
# ----
#  * 어쩌고
# 뉴스
# ----
#  * 저쩌

def check_connection
  begin
    open( 'http://www.kma.go.kr' )
    open( 'http://www.kma.go.kr' )
    open( 'http://api.sbs.co.kr' )
    return true
  rescue
    return false  
  end
end

def get_date
  time = Time.new
  date = time.strftime('%Y-%m-%d') 
  date += "\n=========="
  return date
end

def get_weather
  weather = "\n\nWeather" 
  weather += "\n--------"
  begin
    #http://www.kma.go.kr/weather/lifenindustry/sevice_rss.jsp
    doc = REXML::Document.new open( 'http://www.kma.go.kr/wid/queryDFSRSS.jsp?zone=1114060500' ).read
    weather += "\n * #{doc.elements.to_a('rss/channel/item/category').first.text}"
    weather += "\n * #{doc.elements.to_a('rss/channel/item/description/body/data/wfKor').first.text}"
    
    doc = REXML::Document.new open( 'http://www.kma.go.kr/weather/forecast/mid-term-rss.jsp?stnId=108' ).read
    weather += "\n * #{doc.elements.to_a('rss/channel/item/description/header/wf').first.text}"
  rescue
    weather += "\n * error"
  end
  return weather
end


def get_news
  news = "\n\nNews"
  news += "\n----"
  begin
    open('http://api.sbs.co.kr/xml/news/rss.jsp?pmDiv=all') do |rss|
      feed = RSS::Parser.parse(rss)
      news += "\n * #{feed.channel.title}"
      feed.items.each do |item|
        news += "\n * #{item.title}"
      end
    end
  rescue
    news += "\n * error"
  end
  return news
end

if __FILE__ == $0
  if check_connection
    puts get_date() + get_weather() + get_news()
  end
end
