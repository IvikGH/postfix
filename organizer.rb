require_relative 'parser'
require_relative 'sender'

class Organizer
  attr_reader :filename
  attr_accessor :jsons

  def initialize(filename)
    @filename = filename
    @jsons = []
  end

  def process_bounces
    loop do
      get_bounces_json
      while @jsons.size >= 10
        result = Sender.new.process(jsons[0,10])
        @jsons = @jsons.drop(10) if result
      end
      sleep 5
    end
  end

  def bounce?(line)
    !(/status=bounced/.match(line).nil?)
  end

  def get_bounces_json
    file = File.new(filename)
    parser = Parser.new

    file.each do |line|
      jsons << parser.parse_bounce(line) if bounce?(line)
    end

    File.open(filename,"w") { |file| file.write('') }
  end
end
