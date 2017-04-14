require "net/http"
require "uri"
require "json"
require "time"

url = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/buildingFootprint/")

#send_event('mychart', points:[
#	['Time', 'Energy', 'Expenses'],
#	['1', 1000, 400],
#	['2', 1170, 460],
#	['3', 660, 1120],
#	['4', 1030, 540]
#])

data = [['Time', 'Energy', 'Lights', 'HVAC'], [0, 0, 0, 0]]


(1..500).each do |i|
	h, m, s = Time.now.strftime("%H:%M:%S").split(":").map(&:to_i)
	#h = (h - 4) % 24
	data << [[h, m, s], 0, 0, 0]
end
#x = data.last[0]
x = 500
SCHEDULER.every '2s' do
	response = Net::HTTP.get_response(url)
	parsed = JSON.parse(response.body)
	x += 2
	timeval = Time.at(x).utc.strftime("%H:%M:%S")
	h, m, s = Time.now.strftime("%H:%M:%S").split(":").map(&:to_i)
	#h = (h - 4) % 24
	dataPoint = [[h, m, s], parsed["HVAC"], parsed["Light"], parsed["Electrical"]]
	data.shift
	data[0] = ['Time', 'HVAC', 'Lights', 'Plug Loads']
	data << dataPoint
	#puts data[0]
	send_event('mychart', points: data)
	#send_event('testchart', points: data)
	#send_event('testchart', points2: data)
end
