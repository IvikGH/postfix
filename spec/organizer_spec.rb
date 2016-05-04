require_relative '../organizer'

describe Organizer do
  let(:bounce_line) { 'Apr 19 23:33:07 www postfix/smtp[24970]: 0EEAA211783: to=<root@e-xecutive.ru>, orig_to=<root>, relay=mx.yandex.net[213.180.204.89]:25, delay=0.35, delays=0.27/0.01/0.02/0.05, dsn=5.7.1, status=bounced (host mx.yandex.net[213.180.204.89] said: 550 5.7.1 No such user! (in reply to RCPT TO command))
' }
  let(:filename) {'spec/postfix_test.log'}
  let(:organizer) { Organizer.new(filename) }

  it 'gets data with #get_bounces_json' do
    expect{ organizer.get_bounces_json }.to change{ organizer.jsons.size }
  end

  # it 'after #get_bounces_json data file has no data' do
  #   organizer.get_bounces_json
  #   line_count = `wc -l "#{filename}"`.strip.split(' ')[0].to_i
  #   expect(line_count).to eq 0
  # end
end

