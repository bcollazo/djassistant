Rails.application.routes.draw do
  root 'main#index'

  get '/spotify/callback' => 'spotify#callback'
  get '/update' => 'main#update'
  get '/disconnect' => 'main#disconnect'
end
