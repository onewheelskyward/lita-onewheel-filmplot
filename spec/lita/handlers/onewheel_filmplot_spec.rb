require 'spec_helper'

describe Lita::Handlers::OnewheelFilmplot, lita_handler: true do
  it { is_expected.to route_command('filmplot x') }
  it { is_expected.to route_command('plotline x') }

  def mock(file)
    mock = File.open("spec/fixtures/#{file}.html").read
    allow(RestClient).to receive(:get) { mock }
  end

  it 'should get timecop' do
    mock('timecop')
    send_command('filmplot timecop')
    expect(replies.last).to eq "Based on a comic book story, this futuristic film follows the time-travel exploits of policeman Max Walker (Jean Claude Van Damme). In 1994, Walker's wife Melissa (Mia Sara) is about to tell him that she is expecting their first child when they are attacked by a group of criminals. Walker is shot and beaten and lies helplessly on his lawn while he sees their home and his wife blown up by the killers. Ten years later, Walker remains an employee of the Time Enforcement Commission, a federal agency which was set up in 1994 after the U.S. government learned that time travel technology is feasible. The commission's role is to prevent time travel to protect U.S. economic interests. Walker learns that the corrupt Senator McComb (Ron Silver), who helped establish the agency, is exploiting it for personal gain, trying to establish a monopoly on time travel so that he can enrich himself in the stock market. Walker travels back in time to stop McComb from murdering his former partner. At the same time, Walker hopes to rescue his wife, and he learns that the attack on his home was ordered by McComb to stop Walker from foiling his plans. ~ Michael Betzold, Rovi"
  end

  # it '404s' do
  #   mock
  # end
end