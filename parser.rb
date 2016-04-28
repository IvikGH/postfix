require 'json'

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
    match = nil
    regexps.each do |name, regex|
      match = regex.match(data)
      break if match
    end

    if match
      convert_to_json(match)
    else
      raise "No regex for this line."
    end
  end

  def convert_to_json(match)
    hash_bounce = {}

    match.names.each do |key|
      hash_bounce[key] = match[key]
    end
    hash_bounce.to_json
  end
end
