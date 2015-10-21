class MainController < ApplicationController
	# TODO: Move to middleware
	before_filter :get_current_user
	def get_current_user
		@current_user = User.find_by_spotify_id(session[:spotify_id])
	end

	def index
		@request_spotify_authorization_url = SpotifyHelper.authorization_url
	end

	def disconnect
		@current_user.delete
		session[:spotify_id] = nil
		redirect_to root_url
	end
end
