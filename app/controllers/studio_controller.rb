class StudioController < ApplicationController
  def list_playlists
    @playlists = Playlist.order(key: :asc)
  end
  
  def show_playlist
  end
end
