require 'curb'
require 'yajl'

module Trakt
  class Base

    attr_accessor :results
    class << self
      attr_accessor  :username, :password, :api_key
    end

  def self.base_url
    "http://api.trakt.tv"
  end

  def base_url
    Trakt::base_url
  end

  def request
    c = Curl::Easy.new(url)
    c.http_auth_types = :basic
    if self.username && self.password
      c.username = Trakt::username
      c.password = Trakt::password
    end
    c.perform
    parser = Yajl::Parser.new
    parser.parse(c.body_str)
  end


  module User

    class Base < Trakt::Base

      def initialize()
        self.results = request
      end

    end

    class Calendar < Trakt::User::Base

      def url
        "#{base_url}/user/calendar/shows.json/#{Trakt::api_key}/#{Trakt::username}"
      end

    end
  end
end
