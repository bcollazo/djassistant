namespace :emails do
  desc "Send weekly summaries to every user"
  task weekly: :environment do
  	User.find_each do |user|
  		p "Sending email to: " + user.display_name + " " + user.email
  		songs = user.compute_delta
  		WeeklyMailer.weekly_summary(user, songs).deliver_now
  	end
  end

end
