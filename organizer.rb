require_relative 'parser'
require_relative 'sender'
require_relative 'file_manager'
require_relative 'analyzer'

require 'byebug'

class Organizer
  attr_reader :filename
  attr_accessor :jsons, :analyzer

  def initialize(filename)
    # p ' '.rjust(8) + "in organizer initialize(filename)"
    @filename = filename
    @jsons = []
    @analyzer = Analyzer.new
  end

  def process_bounces
    # p ' '.rjust(8) + "in organizer process_bounces"
    file_manager = FileManager.new(filename, 1000)
    file_manager.process_file

    sender = Sender.new
    loop do
      @filename = file_manager.get_next_filename
      # p ' '.rjust(4) + "@filename: #{@filename}"
      if @filename == nil
        sender.process_data
        analyzer.show_result
        return true
      end
      get_bounces_json
      sender.process_data(jsons)
      @jsons.clear
    end
  end

  def get_bounces_json
    # p ' '.rjust(8) + "in organizer get_bounces_json"
    parser = Parser.new
    file = File.new(filename)

    file.each do |log_line|
      parser.data = log_line
      jsons << parser.parse_bounce(analyzer) if parser.bounce_line?
    end
    file.close
    # File.new(filename,"w+") # если нужно затереть обработанные частичные файлы
  end
end
