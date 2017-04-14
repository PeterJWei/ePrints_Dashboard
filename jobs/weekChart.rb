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

data = [['Time', 'Energy'], [0, 0]]


(1..1000).each do |i|
	h, m, s = Time.now.strftime("%H:%M:%S").split(":").map(&:to_i)
	#h = (h - 4) % 24
	data << [i, rand(10000..60000)]
end
#x = data.last[0]
x = 1000
SCHEDULER.every '10s' do
	response = Net::HTTP.get_response(url)
	parsed = JSON.parse(response.body)
	x += 1
	timeval = Time.at(x).utc.strftime("%H:%M:%S")
	h, m, s = Time.now.strftime("%H:%M:%S").split(":").map(&:to_i)
	#h = (h - 4) % 24
	dataPoint = [x, parsed["value"]]
	data.shift
	data[0] = ['Time', 'Power']
	data << dataPoint
	#puts data[0]
	send_event('weekchart', points: data)
	#send_event('testchart', points: data)
	#send_event('testchart', points2: data)
end
