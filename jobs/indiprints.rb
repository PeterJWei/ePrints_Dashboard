require "net/http"
require "uri"
require "json"

url1 = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/?id=785883b2274c4519")
#url2 = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/?id=9432F0A3-660D-4C35-AA63-C7CFDD6D0F4D")
url2 = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/?id=77f93cfd3f2d720a")
url3 = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/?id=eac6547d7ee7b9f")

data1 = [['Time', 'Rishikanth']]
data2 = [['Time', 'Fred Jiang']]
data3 = [['time', 'Stephen']]

(1..500).each do |i|
	h, m, s = Time.now.strftime("%H:%M:%S").split(":").map(&:to_i)
	data1 << [[h, m, s], 0, 0, 0]
	data2 << [[h, m, s], 0, 0, 0]
	data3 << [[h, m, s], 0, 0, 0]
end

x = data1.last[0]
names = ['Rishi', 'Fred Jiang', 'Stephen']

SCHEDULER.every '2s' do
	response1 = Net::HTTP.get_response(url1)
	response2 = Net::HTTP.get_response(url2)
	response3 = Net::HTTP.get_response(url3)

	parsed1 = JSON.parse(response1.body)
	parsed2 = JSON.parse(response2.body)
	parsed3 = JSON.parse(response3.body)

#	puts "rishi", parsed1
#	puts "peter", parsed2

	#x += 1
	#scaledTime = Time.at(x).utc.strftime("%H:%M:%S")
	h, m, s = Time.now.strftime("%H:%M:%S").split(":").map(&:to_i)
	dataPoint1 = [[h, m, s], parsed1["HVAC"].to_i, parsed1["Plugs"].to_i, parsed1["Light"].to_i]
	dataPoint2 = [[h, m, s], parsed2["HVAC"].to_i, parsed2["Plugs"].to_i, parsed2["Light"].to_i]
	dataPoint3 = [[h, m, s], parsed3["HVAC"].to_i, parsed3["Plugs"].to_i, parsed3["Light"].to_i]

	data1.shift
	data2.shift
	data3.shift

	data1[0] = ['Time', 'HVAC', 'Plug Loads', 'Light']
	data2[0] = ['Time', 'HVAC', 'Plugs Loads', 'Light']
	data3[0] = ['Time', 'HVAC', 'Plugs Loads', 'Light']

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

	send_event('testchart', points: order[max], title1: "#1 "+names[max], points2: order[mid], title2: "#2 " + names[mid], points3: order[min], title3: "#3 " + names[min])

	
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

