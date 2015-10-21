class SpotifyController < ApplicationController
	def callback
		if params[:error]
			redirect_to root_url
		else
			code = params[:code]
			state = params[:state]
			res = SpotifyHelper.request_token(params[:code])
			if res.status == 200
				res_data = JSON.parse(res.body)
				#TODO: move to SpotifyHelper
				profile = Faraday.get "https://api.spotify.com/v1/me", {},
					{:Authorization => "Bearer " + res_data['access_token']}
				profile_data = JSON.parse(profile.body)
				
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