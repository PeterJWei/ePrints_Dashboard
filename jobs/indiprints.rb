require "net/http"
require "uri"
require "json"

url1 = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/?id=785883b2274c4519")
url2 = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/?id=9432F0A3-660D-4C35-AA63-C7CFDD6D0F4D")

data1 = [['Time', 'Rishi']]
data2 = [['Time', 'Peter']]

(1..500).each do |i|
	data1 << [i, 0]
	data2 << [i, 0]
end
x = data1.last[0]

SCHEDULER.every '2s' do
	response1 = Net::HTTP.get_response(url1)
	response2 = Net::HTTP.get_response(url2)
	parsed1 = JSON.parse(response1.body)
	parsed2 = JSON.parse(response2.body)
	puts "rishi", parsed1
	puts "peter", parsed2
	x += 1
	dataPoint1 = [x, parsed1["value"]]
	dataPoint2 = [x, parsed2["value"]]
	data1.shift
	data2.shift
	data1[0] = ['Time', 'Rishi']
	data2[0] = ['Time', 'Peter']

	data1 << dataPoint1
	data2 << dataPoint2
	if parsed2["value"] > parsed1["value"]
		puts "Peters is greater"
		send_event('testchart', points: data2)
		send_event('testchart', points2: data1)
	else
		puts "rishi is greater"
		send_event('testchart', points: data1)
		send_event('testchart', points2: data2)
	end
end 

