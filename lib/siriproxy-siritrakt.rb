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

  def parse_number(str)
    numbers = {
      'one' => 1,
      'two' => 2,
      'three' => 3,
      'four' => 4,
      'five' => 5,
      'six' => 6,
      'seven' => 7,
      'eight' => 8,
      'nine' => 9,
      'ten' => 10
    }
    return numbers[str] || str.to_i
  end

  listen_for /i just saw season (.*) episode (.*) of (.*)/i do |season, episode, show|
    puts "Marking S#{parse_number(season)} E#{parse_number(episode)} of #{show} as seen"
    request = Trakt::Show::Episode::Seen.new(parse_number(season), parse_number(episode), show)

    say request.results['message']
    request_completed
  end

  listen_for /what's on tv tonight/i do
    object = SiriAddViews.new
    object.make_root(last_ref_id)
    object.views << SiriAssistantUtteranceView.new("Here is your trakt calendar!")

    episodes = Trakt::User::Calendar.new.results.first['episodes']
    episodes.each do |calendar_result|
      object.views << SiriAssistantUtteranceView.new(calendar_result['show']['title'])
    end
    object
    send_object object
    request_completed
  end

end


