
module MyCrawler
  class Base
    require 'capybara/poltergeist'

    class << self
      def run
        setup
        self.new.execute
      end

      def setup
        Capybara.register_driver :poltergeist do |app|
          Capybara::Poltergeist::Driver.new(app, {
            js_errors: false,
            timeout: 5000,
            window_size: [1600, 768]
          })
        end
      end
    end

    def initialize
    end

    def execute
    end

    def session
      @session ||= new_session
    end

    def new_session
      Capybara::Session.new(:poltergeist).tap do |session|
        session.driver.headers = session_headers
      end
    end

    def save_screenshot(filename = nil)
      filename ||= Time.now.strftime('%Y%m%d%H%M%S') + '.png'
      session.save_screenshot(filename)
    end

    def session_headers
      {
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 [Hamamatsu.rb]',
        'Accept-Language' => 'ja,en-US;q=0.8,en;q=0.6'
      }
    end
  end
end
