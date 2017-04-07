require "net/http"
require "uri"
require "json"


url=URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/buildingFootprint/")

current_valuation = 0
current_karma = 0

response = Net::HTTP.get_response(url)
parsed = JSON.parse(response.body)
current_energy = (parsed["energy"] * 0.19 / 1000).round


SCHEDULER.every '2s' do
  last_valuation = current_valuation
  last_karma     = current_karma
  current_valuation = rand(100)
  current_karma     = rand(200000)
  last_energy = current_energy
  response = Net::HTTP.get_response(url)
  parsed = JSON.parse(response.body)
  current_energy = (parsed["energy"] * 0.19 / 1000).round
  puts current_energy
  if current_energy != last_energy 
    send_event('karma', { current: current_energy, last: last_energy })
    puts "not equal"
  end
  send_event('valuation', { current: current_valuation, last: last_valuation })
  # send_event('karma', { current: current_karma, last: last_karma })
  
  send_event('synergy',   { value: rand(100) })
end
