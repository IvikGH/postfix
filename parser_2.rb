require 'json'
require 'byebug'

class Parser
  attr_accessor :data

  def bounce_line?
    !(/status=bounced/.match(data).nil?)
  end

  def regexps
    { line_with_orig_to: /(?<date>[\w\s:]+)\sTEST\spostfix\/
                          (?<port>[\w\[\]]+):\s
                          (?<ps_id>[A-Z0-9]+):\s
                          to=<(?<to>[\w@\.-]+)>,\s
                          orig_to=<(?<orig_to>[\w@\.-]+)>,\s
                          relay=(?<relay>[\w@\.-\[\]]+),\s
                          delay=(?<delay>\d+),\sstatus=bounced\s.+?
                          said:\s(?<description>.+?)\){2}/x,

      line_without_orig_to: /(?<date>[\w\s:]+)\sTEST\spostfix\/
                             (?<port>[\w\[\]]+):\s
                             (?<ps_id>[A-Z0-9]+):\s
                             to=<(?<to>[\w@\.-]+)>,\s
                             relay=(?<relay>[\w@\.-\[\]]+),\s
                             delay=(?<delay>\d+),\sstatus=bounced\s.+?
                             said:\s(?<description>.+?)\){2}/x }
  end

  def parse_bounce
    get_log_data

    if data
      get_match_data.to_json
    else
      raise "No regex for this line."
    end
  end

  def get_log_data
    match = nil
    regexps.each do |name, regex|
      match = regex.match(@data)
      if match
        @data = match
        break
      end
    end
  end

  def get_match_data
    hash_bounce = {}

    data.names.each do |key|
      hash_bounce[key] = data[key]
    end
    @data = hash_bounce
  end
end
