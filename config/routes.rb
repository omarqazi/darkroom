Rails.application.routes.draw do
  root to: 'channel#index'
  get '/channel', to: 'channel#index'
  get '/channel/:id', to: 'channel#live'
  get '/studio/playlists', to: 'studio#list_playlists'
  get '/studio/playlist', to: 'studio#list_playlists'
  get '/studio/playlist/:id', to: 'studio#show_playlist'
  
end
