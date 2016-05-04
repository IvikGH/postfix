class Analyzer

  attr_accessor :data

  def initialize
    # p ' '.rjust(8) + "in analyzer.rb initialize"
    @data = []
  end

  def take_data(hash_bounce)
    # p ' '.rjust(8) + "in analyzer.rb analyze(hash_bounce)"
    data << hash_bounce
  end

  def show_result
    # p ' '.rjust(8) + "in analyzer.rb show_result"
    result = analyze_data
    result.each do |error, counts|
      p "#{error}: #{counts}"
    end
  end

  def analyze_data
    result = Hash.new(0)
    data.each do |hash|
      key = clear_descriptio(hash[:error])
      result[key] += 1
    end
    result.each.sort_by {|key, value| -value }
  end

  def clear_descriptio(message)
    message = message.gsub(/[\<\>\[\]]/, '')
    message = message.gsub(/\d{10}-[\w]{10}-[\w]{8}/, '') # remove 1461130675-Wg19RWb0gN-btQW9cWZ
    message = message.gsub(/[\w\.\-]+@[\w\-\.]+/, '') #remove emails
    message = message.gsub(/(\w+.)?\w+.\w+\d+\.\d+\.\d+\.\d+/, '') # remove
    message.strip
  end
end
