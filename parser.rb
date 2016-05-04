require 'json'

class Parser
  attr_accessor :data

  def bounce_line?
    # p ' '.rjust(8) + "in parser_2 bounce_line?"
    !(/status=deferred/.match(data).nil?) || !(/status=bounced/.match(data).nil?)
  end

  def regexps
    # p ' '.rjust(8) + "in parser_2 regexps"
    { general: /^(?<date>[\w\s:]+)\s
                www\s
                postfix\/
                (?<port>[\w\[\]]+):\s
                (?<ps_id>[A-Z0-9]+):\s
                to=<(?<to>[:\w@\.-]+)>,\s
                (orig_to=(?<orig_to>[\<\w\>]+),\s)?
                (relay=(?<relay>[\[\]\w@\.:-]+),\s)?
                (conn_use=(?<conn_use>[\[\]\w@\.:-]+),\s)?
                delay=(?<delay>[\.\d]+),\s
                delays=(?<delays>[\d+\/\.]+),\s
                dsn=(?<dsn>[\d\.]+),\s
                status=(?<status>\w+)\s.+?
                said:\s(?<error>[\<\>@\w\.!\s:-]+)/x,

      no_said: /^(?<date>[\w\s:]+)\s
                www\s
                postfix\/
                (?<port>[\w\[\]]+):\s
                (?<ps_id>[A-Z0-9]+):\s
                to=<(?<to>[:\w@\.-]+)>,\s
                (orig_to=(?<orig_to>[\<\w\>]+),\s)?
                (relay=(?<relay>[\[\]\w@\.:-]+),\s)?
                delay=(?<delay>[\.\d]+),\s
                delays=(?<delays>[\d+\/\.]+),\s
                dsn=(?<dsn>[\d\.]+),\s
                status=(?<status>\w+)\s.+?:\s
                (?<error>.+)\)\n$/x,
      # ^(?<date>[\w\s:]+)\swww\spostfix\/(?<port>[\w\[\]]+):\s(?<ps_id>[A-Z0-9]+):\sto=<(?<to>[\w@\.-]+)>,\s(orig_to=(?<orig_to>[\<\w\>]+),\s)?(relay=(?<relay>[\[\]\w@\.:-]+),\s)?delay=(?<delay>[\.\d]+),\sdelays=(?<delays>[\d+\/\.]+),\sdsn=(?<dsn>[\d\.]+),\sstatus=(?<status>\w+)\s\((?<error>[\w\s\.\[\]]+)\)
      no_said_short: /^(?<date>[\w\s:]+)\s
                www\s
                postfix\/
                (?<port>[\w\[\]]+):\s
                (?<ps_id>[A-Z0-9]+):\s
                to=<(?<to>[:\w@\.-]+)>,\s
                (orig_to=(?<orig_to>[\<\w\>]+),\s)?
                (relay=(?<relay>[\[\]\w@\.:-]+),\s)?
                delay=(?<delay>[\.\d]+),\s
                delays=(?<delays>[\d+\/\.]+),\s
                dsn=(?<dsn>[\d\.]+),\s
                status=(?<status>\w+)\s
                \((?<error>[\w\s\.\[\]-]+)\)/x }
  end

  def parse_bounce(analyzer)
    # p ' '.rjust(8) + "in parser_2 parse_bounce(analyzer)"
    get_log_data

    if data
      hash_bounce = get_match_data
      analyzer.take_data(hash_bounce)
      hash_bounce.to_json
    else
      raise "No regex for this line."
    end
  end

  def get_log_data
    # p ' '.rjust(8) + "in parser_2 get_log_data"
    match = nil
    regexps.each do |name, regex|
      match = regex.match(@data)
      if match
        @data = match
        break
      end
    end
    if match.nil?
      raise "No regex for this line."
    end
  end

  def get_match_data
    # p ' '.rjust(8) + "in parser_2 get_match_data"
    hash_bounce = {}
    byebug if data.kind_of?(String)
    data.names.each do |key|
      hash_bounce[key.to_sym] = data[key]
    end
    @data = hash_bounce
  end
end
