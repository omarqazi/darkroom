class CreatePlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :playlists do |t|
      t.string :key
      t.string :playlist_url
      t.jsonb :metadata, null: false, default: '{}'
      t.timestamps
    end
    
    add_index :playlists, :key
    add_index :playlists, :metadata, using: :gin
  end
end
