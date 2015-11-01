class User < ActiveRecord::Base
	has_and_belongs_to_many :songs

	def spotify_connected
		return !spotify_id.nil?
	end

	def compute_delta
		delta_songs = []
		# If not exists, then first time!
		if not self.last_spotify_sync_date.nil?
			next_url = 'https://api.spotify.com/v1/me/tracks'
			loop do
				res = SpotifyHelper.spotify_request(self, next_url)
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
