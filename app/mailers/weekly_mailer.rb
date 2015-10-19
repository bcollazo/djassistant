class WeeklyMailer < ApplicationMailer
	def weekly_summary(user, songs)
		@user = user
		@songs = songs
		mail(to: user.email, subject: "Your Weekly DJAssistant Summary")
	end
end
