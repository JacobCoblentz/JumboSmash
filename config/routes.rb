JumboSmash::Application.routes.draw do
  devise_for :users, :controllers => {:sessions => "sessions", :registrations => "registrations"}

  root :to => 'dashboard#index'
  # root :to => 'application#index'
  match '/people_search' => 'dashboard#people_search', :via => :get
  match '/request' => 'dashboard#make_request', :via => :post
  match '/teaser' => 'teaser#create', :via => :post
  resources :checkins, :only => [:create, :index]
  # namespace :api do
  #   resources :tokens, :only => [:create, :destroy]
  # end
end
