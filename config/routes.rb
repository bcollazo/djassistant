Rails.application.routes.draw do
  root 'main#index'
  get '/contact' => 'main#contact'

  get '/spotify/callback' => 'spotify#callback'
  get '/soundcloud/callback' => 'soundcloud#callback'
  get '/unsubscribe' => 'main#disconnect'
  post '/submit' => 'main#submit'

  get '/update' => 'main#update'
end
