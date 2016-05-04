require_relative '../analyzer'

describe Analyzer do
  let (:analyzer) { Analyzer.new }

  it '#take_data gather data' do
    hash_bounce = { key_1: 'value_1', key_2: 'value_2' }

    expect{analyzer.take_data(hash_bounce)}.to change{analyzer.data.size}.to(1)
  end

  it '#analyze_data properly' do
    analyzer.data = [{ error: 'error_1'}, {error: 'error_2'}, {error: 'error_1'}]

    expect(analyzer.analyze_data).to eq([["error_1", 2], ["error_2", 1]])
  end
end
