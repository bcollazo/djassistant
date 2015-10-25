Rails.application.routes.draw do
  root 'main#index'

  get '/spotify/callback' => 'spotify#callback'
  get '/update' => 'main#update'
  get '/unsubscribe' => 'main#disconnect'
  get '/contact' => 'main#contact'
end
