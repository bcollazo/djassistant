class User < ActiveRecord::Base
	has_and_belongs_to_many :songs

	def self.spotify_request(user, endpoint) \
		# TODO: Change to first check if expired by time.  Refresh, then do 1 call
		res = Faraday.get endpoint, {},
			{:Authorization => "Bearer " + user.access_token}

		if res.status == 401
			client_id = @@SPOTIFY_CONFIG['client_id']
			client_secret = @@SPOTIFY_CONFIG['client_secret']
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

	def compute_delta
		# Get Last Song Seen.  If not exists, then first time!
		if not self.last_spotify_sync_date.nil?
			next_url = 'https://api.spotify.com/v1/me/tracks'
			delta_songs = []
			loop do
				res = User.spotify_request(self, next_url)
				data = JSON.parse(res.body)
				next_url = data['next']

				data['items'].each do |item|
					song_date = item['added_at'].to_datetime
					if song_date > self.last_spotify_sync_date
						artists = []
						item['track']['artists'].each do |artist|
							artists << artist['name']
						end
						artists = artists.sort.join(' ')

						song = Song.find_or_create_by(name: item['track']['name'], artists: artists)
						delta_songs << song
					else
						next_url = nil
						break
					end
				end
				break if next_url.nil?
			end
		end
		self.last_spotify_sync_date = DateTime.now
		self.songs.push(*delta_songs)
		self.save

		return delta_songs
	end
end
