require 'typhoeus'
require 'yajl'
require 'date'

module Trakt

  def self.base_url
    "http://api.trakt.tv"
  end

  class << self
    attr_accessor  :username, :password, :api_key
  end

  class Base
    attr_accessor :results

    def initialize()
      self.results = request
    end

    def base_url
      Trakt::base_url
    end

    def request
      response = Typhoeus::Request.get(url)
      parser = Yajl::Parser.new
      parser.parse(response.body)
    end
  end

  module User

    class Calendar < Trakt::Base

      def url
        "#{base_url}/user/calendar/shows.json/#{Trakt::api_key}/#{Trakt::username}/#{Date.today.to_s}/1"
      end

    end

  end

end
