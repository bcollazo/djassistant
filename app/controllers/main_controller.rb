class MainController < ApplicationController
	require 'faraday'
	require 'open-uri'
	require 'base64'
	require 'json'
	@@SPOTIFY_CONFIG = YAML::load(File.open("#{Rails.root}/config/spotify.yml"))
	before_filter :get_current_user

	def get_current_user
		@current_user = User.find_by_spotify_id(session[:spotify_id])
	end

	def index
		@request_spotify_authorization_url = %(
			https://accounts.spotify.com/authorize?
			client_id=#{@@SPOTIFY_CONFIG['client_id']}
			&response_type=code
			&redirect_uri=#{@@SPOTIFY_CONFIG['redirect_uri']}
			&scope=playlist-read-private user-read-email user-library-read
		)
	end

	def logout
		session[:spotify_id] = nil
		redirect_to root_url
	end

	def disconnect
		@current_user.delete
		session[:spotify_id] = nil
		redirect_to root_url
	end

	# def update
	# 	user = User.find_by_spotify_id(session[:spotify_id])

	# 	# Get Last Song Seen.  If not exists, then first time!
	# 	if not user.last_spotify_sync_date.nil?
	# 		next_url = 'https://api.spotify.com/v1/me/tracks'
	# 		loop do
	# 			p next_url
	# 			res = spotify_request(user, next_url)
	# 			data = JSON.parse(res.body)
	# 			next_url = data['next']

	# 			data['items'].each do |item|
	# 				song_date = item['added_at'].to_datetime
	# 				if song_date > user.last_spotify_sync_date
	# 					artists = []
	# 					item['track']['artists'].each do |artist|
	# 						artists << artist['name']
	# 					end
	# 					artists = artists.sort.join(' ')
	# 					p artists
	# 					song = Song.find_or_create_by(name: item['track']['name'], artists: artists)
	# 					user.songs << song
	# 				else
	# 					next_url = nil
	# 					break
	# 				end
	# 			end
	# 			break if next_url.nil?
	# 		end
	# 	end
	# 	user.last_spotify_sync_date = DateTime.now
	# 	user.save

	# 	render json: user.songs
	# end

	def spotifycallback
		if params[:error]
			redirect_to root_url
		else
			code = params[:code]
			state = params[:state]
			client_id = @@SPOTIFY_CONFIG['client_id']
			client_secret = @@SPOTIFY_CONFIG['client_secret']
			res = Faraday.post 'https://accounts.spotify.com/api/token',
				:grant_type => "authorization_code", :code => params[:code],
				:redirect_uri => @@SPOTIFY_CONFIG['redirect_uri'],
				:client_id => client_id, :client_secret => client_secret # TODO: Move to Header
			if res.status == 200
				res_data = JSON.parse(res.body)
				profile = Faraday.get "https://api.spotify.com/v1/me", {},
					{:Authorization => "Bearer " + res_data['access_token']}
				profile_data = JSON.parse(profile.body)
				p profile_data
				user = User.find_or_create_by(:display_name => profile_data['display_name'],
					:email => profile_data['email'], :spotify_id => profile_data['id'])
				user.access_token = res_data['access_token']
				user.refresh_token = res_data['refresh_token']
				user.save
				session[:spotify_id] = user.spotify_id
			else
				flash[:notice] = "Error #{res.status} Authenticating with Spotify"
			end
			redirect_to root_url
		end
	end
end
