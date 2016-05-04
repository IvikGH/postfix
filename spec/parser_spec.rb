require_relative '../parser'
require 'json'

describe Parser do
  let(:bounce_line) { 'Apr 19 23:33:07 www postfix/smtp[24970]: 0EEAA211783: to=<root@e-xecutive.ru>, orig_to=<root>, relay=mx.yandex.net[213.180.204.89]:25, delay=0.35, delays=0.27/0.01/0.02/0.05, dsn=5.7.1, status=bounced (host mx.yandex.net[213.180.204.89] said: 550 5.7.1 No such user! (in reply to RCPT TO command))
' }
  let(:not_bounce_line) { 'Apr 19 23:33:07 www postfix/smtp[24970]: 0EEAA211783: to=<root@e-xecutive.ru>, orig_to=<root>, relay=mx.yandex.net[213.180.204.89]:25, delay=0.35, delays=0.27/0.01/0.02/0.05, dsn=5.7.1, status=success (host mx.yandex.net[213.180.204.89] said: 550 5.7.1 No such user! (in reply to RCPT TO command))
' }
  let(:incorrect_bounce_line) { 'Apr 19 23:33:07 www postfix/smtp[24970]: 0EEAA211783: to=<root@e-xecutive.ru>, orig_to=<root>, relay=mx.yandex.net[213.180.204.89]:25, delay=0.35, something, delays=0.27/0.01/0.02/0.05, dsn=5.7.1, status=bounced (host mx.yandex.net[213.180.204.89] said: 550 5.7.1 No such user! (in reply to RCPT TO command))
' }
  let(:parser) { Parser.new }
  let(:analyzer) { Analyzer.new }

  it '#bounce? detects line with "status=bounced"' do
    parser.data = bounce_line
    expect(parser.bounce_line?).to be_truthy
  end

  it '#bounce? does not detect line without "status=bounced"' do
    parser.data = not_bounce_line
    expect(parser.bounce_line?).to be_falsey
  end

  it '#parse_bounce and #convert_to_json parses lines correctly' do
    manual_parser = Parser.new
    manual_parser.data = bounce_line
    match = nil
    manual_parser.regexps.each do |name, regex|
      match = regex.match(manual_parser.data)
      break if match
    end

    hash_bounce = {}
    match.names.each do |key|
      hash_bounce[key] = match[key]
    end
    manual_json = hash_bounce.to_json
    parser.data = bounce_line
    method_json = parser.parse_bounce(analyzer)

    expect(manual_json == method_json).to be_truthy
  end

  it '#parse_bounce raise "No regex for this line."'\
     ' if log line does not have all fields' do
    expect { parser.parse_bounce(analyzer) }
      .to raise_error('No regex for this line.')
  end

  it '#get_log_data create MatchData from String' do
    parser.data = bounce_line
    expect(parser.data.kind_of?(String)).to be_truthy
    parser.get_log_data
    expect(parser.data.kind_of?(String)).to be_falsey
    expect(parser.data.kind_of?(MatchData)).to be_truthy
  end

  it '#get_match_data create Hash from MatchData' do
    parser.data = bounce_line
    parser.get_log_data
    expect(parser.data.kind_of?(MatchData)).to be_truthy
    parser.get_match_data
    expect(parser.data.kind_of?(MatchData)).to be_falsey
    expect(parser.data.kind_of?(Hash)).to be_truthy
  end
end
