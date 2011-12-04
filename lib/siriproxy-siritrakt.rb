require 'cora'
require 'siri_objects'
require 'trakt'

#######
######

class SiriProxy::Plugin::SiriTrakt < SiriProxy::Plugin
  def initialize(config)
    Trakt::api_key = config['trakt_api_key']
    Trakt::username = config['trakt_username']
    Trakt::password = config['trakt_password']
  end

  def generate_calendar_response(ref_id)
    object = SiriAddViews.new
    object.make_root(ref_id)
    object.views << SiriAssistantUtteranceView.new("Here is your trakt calendar!")

    episodes = Trakt::User::Calendar.new.results.first['episodes']
    episodes.each do |calendar_result|
      object.views << SiriAssistantUtteranceView.new(calendar_result['show']['title'])
    end
    object
  end

  listen_for /what's on tv tonight/i do
    send_object self.generate_calendar_response(last_ref_id)
    request_completed
  end

end


