require 'json'

class Parser
  attr_reader :regex, :keys

  def initialize
    @regex = /(?<date>[\w\s:]+)\sTEST\spostfix\/
             (?<port>[\w\[\]]+):\s
             (?<ps_id>[A-Z0-9]+):\s
             to=<(?<to>[\w@\.-]+)>,\s
             orig_to=<(?<orig_to>[\w@\.-]+)>,\s
             relay=(?<relay>[\w@\.-\[\]]+),\s
             delay=(?<delay>\d+),\sstatus=bounced\s.+?
             said:\s(?<description>.+?)\){2}/x

    @keys = [:date, :port, :ps_id, :to, :orig_to, :relay, :delay, :description]
  end

  def parse_bounce(line)
    match = regex.match(line)

    raise "Some keys missing in log line" unless match

    convert_to_json(match, keys) if match
  end

  def convert_to_json(match, keys)
    bounce = {}

    keys.each do |key|
      bounce[key] = match[key]
    end
    bounce.to_json
  end
end


