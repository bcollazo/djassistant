require 'date'
namespace :emails do
  desc "Send weekly summaries to every user"
  task weekly: :environment do
    if Date.today.friday?
    	User.find_each do |user|
    		if not user.email.nil?
  	  		p "Sending email to: " + user.display_name + " " + user.email
  	  		songs = user.compute_delta
  	  		WeeklyMailer.weekly_summary(user, songs).deliver_now
  	  	end
    	end
    end
  end
end
