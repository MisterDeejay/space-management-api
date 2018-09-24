Rails.application.routes.draw do
  resources :stores do
    resources :spaces
    get '/spaces/:id/price/:start_date/:end_date', to: 'spaces#price'
  end
end
