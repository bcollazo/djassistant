# Preview all emails at http://localhost:3000/rails/mailers/weekly_mailer
class WeeklyMailerPreview < ActionMailer::Preview

  def nosongs
    WeeklyMailer.weekly_summary(User.first, [])
  end

  def somesongs
    WeeklyMailer.weekly_summary(User.first, Song.all.limit(10))
  end

end
