require 'typhoeus'
require 'yajl'
require 'date'
require 'digest/sha1'
require 'cgi'

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

  module Show

    class Search < Trakt::Base

      attr_accessor :query

      def initialize(query)
        self.query = CGI::escape(query)
        self.results = request
      end

      def url
        "#{base_url}/search/shows.json/#{Trakt::api_key}/#{query}"
      end

      def tvdb_id
        results.first['tvdb_id']
      end

    end

    module Episode

      class Seen < Trakt::Base

        attr_accessor :season, :episode, :show

        def initialize(season, episode, show)
          self.season, self.episode, self.show = season, episode, show
          self.results = request
        end

        def request
          response = Typhoeus::Request.post(
            url,
            :body => body
          )
          parser = Yajl::Parser.new
          parser.parse(response.body)
        end

        def url
          "#{base_url}/show/episode/seen/#{Trakt::api_key}"
        end

        def body
          Yajl::Encoder.encode({
            :username => Trakt::username,
            :password => Digest::SHA1.hexdigest(Trakt::password),
            :tvdb_id => Trakt::Show::Search.new(show).tvdb_id,
            :episodes => [
              {
                :season => season,
                :episode => episode
              }
            ]
          })
        end
      end

    end

  end

end
