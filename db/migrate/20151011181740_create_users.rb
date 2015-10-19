class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :display_name
      t.string :spotify_id
      t.string :email
      t.string :access_token
      t.string :refresh_token
      t.datetime :last_spotify_sync_date

      t.timestamps null: false
    end
  end
end
