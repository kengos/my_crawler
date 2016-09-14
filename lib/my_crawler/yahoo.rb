module MyCrawler
  class Yahoo < ::MyCrawler::Base
    # require 'datetime'
    def execute
      session.visit 'http://news.yahoo.co.jp/list/'
      news_list = collect_news_summary

      # page = 1
      # while session.first(:css, 'a.next') != nil || page <= 2
      #   session.first(:css, 'a.next').click
      #   news = news + collect_news_summary
      #   page += 1
      # end
      #
      collect_news_details(news_list.first)
      news_list.each do |news|
        news.body = collect_news_details(news)
      end
      p news_list[2]
    end

    def collect_news_summary
      [].tap do |result|
        session.find_all(:css, 'ul.list li a').each do |link|
          image = link.first(:css, 'img')
          result << News.new({
            url: link[:href],
            title: link.find(:css, 'span.ttl').text,
            image_url: image ? image[:src] : nil,
            category: link.find(:css, 'span.cate').text,
            # localtime
            date: Time.strptime(link.find(:css, 'span.date').text, '%Y年%m月%d日 %H時%M分')
          })
        end
      end
    end

    def collect_news_details(news)
      session.visit news.url
      if url = session.first(:css, 'a.newsLink')
        session.visit url[:href]
        body = session.first(:css, 'div#ym_newsarticle')
        return body ? body.text : nil
      else
        return nil
      end
    end

    class News
      attr_accessor :url
      attr_accessor :title
      attr_accessor :image_url
      attr_accessor :category
      attr_accessor :date
      attr_accessor :body

      def initialize(attributes = {})
        self.url = attributes[:url]
        self.title = attributes[:title]
        self.image_url = attributes[:image_url]
        self.category = attributes[:category]
        self.date = attributes[:date]
      end
    end
  end
end
