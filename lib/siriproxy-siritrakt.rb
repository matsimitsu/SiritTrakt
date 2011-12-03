require 'cora'
require 'siri_objects'
require 'imdb'

#######
######

class SiriProxy::Plugin::SiriTrakt < SiriProxy::Plugin
  def initialize(config)
    Trakt::api_key = config.trakt_api_key
    Trakt::username = config.trakt_username
    Trakt::password = config.trakt_password
  end

  def getCalendar()
  	calendar = Trakt::User::Calendar.new
    results = calendar.results
  	return results
  end

  listen_for /whats on tv tonight/i do
  	movieTitle = movieTitle.split(' ').map {|w| w.capitalize }.join(' ')
  	#Search for the movie and get the rating as a string
  	calendar = getCalendar()
    request_completed
  end

end
