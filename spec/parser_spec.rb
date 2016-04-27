require_relative '../parser'
require 'json'

describe Parser do
  let(:bounce_line) { 'May 24 12:51:53 TEST postfix/smtp[7203]: 1746B93F7F: to=<root@localhost.lab.ru>, orig_to=<root@localhost>, relay=localhost.lab.ru[194.135.30.57], delay=5, status=bounced (host localhost.lab.ru[194.135.30.57] said: 550 5.7.1 <root@localhost.lab.ru>... Relaying denied (in reply to RCPT TO command))' }
  let(:incorrect_bounce_line) { 'May 24 12:57:15 TEST postfix/smtp[7211]: 4182593F7F: to=<root@localhost.lab.ru>, relay=localhost.lab.ru[194.135.30.57], delay=11, status=bounced (host localhost.lab.ru[194.135.30.57] said: 550 5.7.1 <root@localhost.lab.ru>... Relaying denied (in reply to RCPT TO command))' }
  let(:parser) { Parser.new }

  it '#parse_bounce and #convert_to_json parses lines correctly' do
    manual_parser = Parser.new
    manual_parser.parse_bounce(bounce_line)
    match = manual_parser.regex.match(bounce_line)
    bounce = {}
    manual_parser.keys.each do |key|
      bounce[key] = match[key]
    end
    manual_json = bounce.to_json

    method_json = parser.parse_bounce(bounce_line)

    expect(manual_json == method_json).to be_truthy
  end

  it 'raise "Some keys missing in log line" if log line doesnt have all fields' do
    expect { parser.parse_bounce(incorrect_bounce_line) }
      .to raise_error('Some keys missing in log line')
  end
end
