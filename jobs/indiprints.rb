require "net/http"
require "uri"
require "json"

url1 = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/?id=785883b2274c4519")
url2 = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/?id=9432F0A3-660D-4C35-AA63-C7CFDD6D0F4D")
url3 = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/?id=eac6547d7ee7b9f")

data1 = [['Time', 'Rishi']]
data2 = [['Time', 'Peter']]
data3 = [['time', 'Stephen']]

(1..500).each do |i|
	data1 << [i, 0, 0, 0]
	data2 << [i, 0, 0, 0]
	data3 << [i, 0, 0, 0]
end

x = data1.last[0]

SCHEDULER.every '2s' do
	response1 = Net::HTTP.get_response(url1)
	response2 = Net::HTTP.get_response(url2)
	response3 = Net::HTTP.get_response(url3)

	parsed1 = JSON.parse(response1.body)
	parsed2 = JSON.parse(response2.body)
	parsed3 = JSON.parse(response3.body)

#	puts "rishi", parsed1
#	puts "peter", parsed2

	x += 1
	scaledTime = Time.at(x).utc.strftime("%H:%M:%S")
	dataPoint1 = [x, parsed1["Electrical"], parsed1["Light"], parsed1["HVAC"]]
	dataPoint2 = [x, parsed2["Electrical"], parsed2["Light"], parsed2["HVAC"]]
	dataPoint3 = [x, parsed3["Electrical"], parsed3["light"], parsed3["HVAC"]]

	data1.shift
	data2.shift
	data3.shift

	data1[0] = ['Time', 'Electrical', 'Light', 'HVAC']
	data2[0] = ['Time', 'Electrical', 'Light', 'HVAC']
	data3[0] = ['Time', 'Electrical', 'Light', 'HVAC']

	data1 << dataPoint1
	data2 << dataPoint2
	data3 << dataPoint3

	order = [data1, data2, data3]
	min = max = mid = 0
	
	if parsed1["value"] > parsed2["value"]
		if parsed1["value"] > parsed3["value"]
			max = 0
			if parsed2["value"] > parsed3["value"]
				mid = 1
				min = 2
			else
				mid = 2
				min = 1
			end
		else
			mid = 0
			max = 2
			min = 1
		end
	else
		if parsed2["value"] > parsed3["value"]
			max = 1
		else
			max = 2
			mid = 1
			min = 0
		end
	end

	send_event('testchart', points: order[max], points2: order[mid], points3: order[min])

	
#	if parsed2["value"] > parsed1["value"] 
#		puts "Peters is greater"
#		send_event('testchart', points: data2)
#		send_event('testchart', points2: data1)
#	else
#		puts "rishi is greater"
#		send_event('testchart', points: data1)
#		send_event('testchart', points2: data2)
#	end
end 

