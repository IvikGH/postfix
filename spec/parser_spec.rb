require_relative '../parser'
require 'json'

describe Parser do
  let(:bounce_line) { 'May 24 12:51:53 TEST postfix/smtp[7203]: 1746B93F7F: to=<root@localhost.lab.ru>, orig_to=<root@localhost>, relay=localhost.lab.ru[194.135.30.57], delay=5, status=bounced (host localhost.lab.ru[194.135.30.57] said: 550 5.7.1 <root@localhost.lab.ru>... Relaying denied (in reply to RCPT TO command))' }
  let(:not_bounce_line) { 'May 24 12:51:53 TEST postfix/smtp[7203]: 1746B93F7F: to=<root@localhost.lab.ru>, orig_to=<root@localhost>, relay=localhost.lab.ru[194.135.30.57], delay=5, status=deffered (host localhost.lab.ru[194.135.30.57] said: 550 5.7.1 <root@localhost.lab.ru>... Relaying denied (in reply to RCPT TO command))' }
  let(:incorrect_bounce_line) { 'May 24 12:57:15 TEST postfix/smtp[7211]: 4182593F7F: to=<root@localhost.lab.ru>, relay=localhost.lab.ru[194.135.30.57], delay=11, status=bounced (host localhost.lab.ru[194.135.30.57] said: 550 5.7.1 <root@localhost.lab.ru>... Relaying denied (in reply to RCPT TO command))' }
  let(:parser) { Parser.new }


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
    method_json = parser.parse_bounce

    expect(manual_json == method_json).to be_truthy
  end

  it '#parse_bounce raise "No regex for this line."'\
     ' if log line does not have all fields' do
    expect { parser.parse_bounce }
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
