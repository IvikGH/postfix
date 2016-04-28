require_relative 'parser_2'
require_relative 'sender'

class Organizer
  attr_reader :filename
  attr_accessor :jsons

  def initialize(filename)
    @filename = filename
    @jsons = []
  end

  def process_bounces
    sender = Sender.new

    loop do
      get_bounces_json
      sender.process(jsons)
      @jsons.clear
      sleep 5
    end
  end



  def get_bounces_json
    file = File.new(filename)
    parser = Parser.new

    file.each do |log_line|
      parser.data = log_line
      jsons << parser.parse_bounce if parser.bounce_line?
    end
    file.close

    File.new(filename,"w+")
  end
end
