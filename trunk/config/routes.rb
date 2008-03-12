ActionController::Routing::Routes.draw do |map|
  map.resources :projects

  map.resources :tasks


  map.resources :tasks
  map.resources :lists  
  map.resources :users

  
end
