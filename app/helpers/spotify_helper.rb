module SpotifyHelper
	require 'faraday'
	require 'open-uri'
	require 'base64'

	@@CLIENT_ID = ENV['SPOTIFY_CLIENT_ID']
	@@CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET']
	@@REDIRECT_URI = (Rails.env.production? ? 
		"http://djassistant.club" : "http://localhost:3000") + 
		"/spotify/callback"
	@@AUTHORIZATION_URL = %(
			https://accounts.spotify.com/authorize?
			client_id=#{@@CLIENT_ID}
			&response_type=code
			&redirect_uri=#{@@REDIRECT_URI}
			&scope=playlist-read-private user-read-email user-library-read
		)

	def self.client_id
		return @@CLIENT_ID
	end
	def self.client_secret
		return @@CLIENT_SECRET
	end
	def self.authorization_url
		return @@AUTHORIZATION_URL
	end

	def self.spotify_request(user, endpoint)
		# TODO: Change to first check if expired by time.  Refresh, then do 1 call
		res = Faraday.get endpoint, {},
			{:Authorization => "Bearer " + user.access_token}

		if res.status == 401
			client_id = @@CLIENT_ID
			client_secret = @@CLIENT_SECRET
			refresh_res = Faraday.post "https://accounts.spotify.com/api/token", {
				:grant_type => "refresh_token", :refresh_token => user.refresh_token,
				:client_id => client_id, :client_secret => client_secret # TODO: Move to Header
			}
			refresh = JSON.parse(refresh_res.body)
			user.access_token = refresh['access_token']
			user.save

			return Faraday.get endpoint, {},
				{:Authorization => "Bearer " + user.access_token}
		else
			return res
		end
	end

	def self.request_token(code)
		return Faraday.post 'https://accounts.spotify.com/api/token',
				:grant_type => "authorization_code", :code => code,
				:redirect_uri => @@REDIRECT_URI,
				:client_id => @@CLIENT_ID, 
				:client_secret => @@CLIENT_SECRET # TODO: Move to Header
	end
end