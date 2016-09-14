module MyCrawler
  class Yahoo < ::MyCrawler::Base
    # require 'datetime'
    def execute
      session.visit 'http://news.yahoo.co.jp/list/'
      news = []

      session.find_all(:css, 'ul.list li a').each do |link|
        image = link.first(:css, 'img')
        news << NewsSummary.new({
          url: link[:href],
          title: link.find(:css, 'span.ttl').text,
          image_url: image ? image[:src] : nil,
          category: link.find(:css, 'span.cate').text,
          # localtime
          date: Time.strptime(link.find(:css, 'span.date').text, '%Y年%m月%d日 %H時%M分')
        })
      end
      p news
      # save_screenshot 'foo.png'
    end

    class NewsSummary
      attr_accessor :url
      attr_accessor :title
      attr_accessor :image_url
      attr_accessor :category
      attr_accessor :date

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
