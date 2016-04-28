require_relative '../organizer'

describe Organizer do
  let(:bounce_line) { 'May 24 12:51:53 TEST postfix/smtp[7203]: 1746B93F7F: to=<root@localhost.lab.ru>, orig_to=<root@localhost>, relay=localhost.lab.ru[194.135.30.57], delay=5, status=bounced (host localhost.lab.ru[194.135.30.57] said: 550 5.7.1 <root@localhost.lab.ru>... Relaying denied (in reply to RCPT TO command))' }
  let(:filename) {'spec/maillog_data'}
  let(:organizer) { Organizer.new(filename) }

  it 'gets data with #get_bounces_json' do
    before = organizer.jsons.size
    organizer.get_bounces_json
    after = organizer.jsons.size
    expect(before).to be < after
  end

  it 'after #get_bounces_json data file has no data' do
    organizer.get_bounces_json
    line_count = `wc -l "#{filename}"`.strip.split(' ')[0].to_i
    expect(line_count).to eq 0
  end
end

