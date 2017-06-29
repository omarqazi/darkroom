Rails.application.routes.draw do
  root to: 'channel#index'
  get '/channel', to: 'channel#index'
  get '/channel/:id', to: 'channel#live'
end
