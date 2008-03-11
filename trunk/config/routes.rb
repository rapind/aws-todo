ActionController::Routing::Routes.draw do |map|
  map.resources :tasks


  map.resources :tasks
  map.resources :lists  
  map.resources :users

  
end
