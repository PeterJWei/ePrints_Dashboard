# fitbit = Fitbit.new

SCHEDULER.every "2s" do
	send_event "fitbit_leaderboard", { people: [{rank: 1, steps: "--", name: "ICSL", avatar: "http://icsl.ee.columbia.edu:3030/assets/fitbit/bicsl.png", style: ""}, {rank: 1, steps: "--", name: "Danino Lab", avatar: "http://icsl.ee.columbia.edu:3030/assets/fitbit/logo-placeholder.jpg", style: ""}, {rank: 1, steps: "--", name: "Burke's Lab", avatar: "http://icsl.ee.columbia.edu:3030/assets/fitbit/logo-placeholder.jpg", style: ""}, {rank: 1, steps: "--", name: "Teherani's Lab", avatar: "http://icsl.ee.columbia.edu:3030/assets/fitbit/logo-placeholder.jpg", style: ""}]}
  # if fitbit.errors?
  #   send_event "fitbit_leaderboard", { error: fitbit.error }
  # else
  #   send_event "fitbit_leaderboard", { people: fitbit.leaderboard }
  # end
end
