require "net/http"
require "uri"
require "json"
require "time"


url=URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/buildingFootprint/")

current_valuation = 0
current_karma = 0

response = Net::HTTP.get_response(url)
parsed = JSON.parse(response.body)
current_energy = (parsed["energy"] * 0.19 / 1000).round(2)
yes_energy = parsed["history"][5]

SCHEDULER.every '60s' do
  last_valuation = current_valuation
  last_karma     = current_karma
  current_valuation = rand(100)
  current_karma     = rand(200000)
  t1 = Time.parse("21:00")
  t2 = Time.parse(Time.now.strftime("%H:%M"))
  diff = ((t1 - t2) / 60).floor
  constF = 24 * 60
  elapsed = constF - diff
  yes_scaled = (elapsed * yes_energy / constF * 0.19 / 1000).round(2)
  puts "yest ener, diff: ", yes_energy, diff, elapsed
  puts "yesterday cost: ", yes_scaled
  
  last_energy = current_energy
  response = Net::HTTP.get_response(url)
  parsed = JSON.parse(response.body)
  current_energy = (parsed["energy"] * 0.19 / 1000).round(2)
  send_event('karma', { current: current_energy, last: yes_scaled })
  #puts current_energy
  #if current_energy != last_energy 
   # send_event('karma', { current: current_energy, last: last_energy })
    #puts "not equal"
  #end
 # send_event('valuation', { current: current_valuation, last: last_valuation })
  # send_event('karma', { current: current_karma, last: last_karma })
  
#  send_event('synergy',   { value: rand(100) })
end
