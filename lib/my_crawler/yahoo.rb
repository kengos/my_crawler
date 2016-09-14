module MyCrawler
  class Yahoo < ::MyCrawler::Base
    def execute
      session.visit 'http://news.yahoo.co.jp/'
      save_screenshot 'foo.png'
    end
  end
end
