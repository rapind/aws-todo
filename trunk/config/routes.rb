ActionController::Routing::Routes.draw do |map|

  # restful_authentication session mappings
  map.resource :session, :controller => 'session'
  map.login  '/login', :controller => 'session', :action => 'new'
  map.logout '/logout', :controller => 'session', :action => 'destroy'
  
  # resource mappings
  map.resources :tasks, :collection => {:destroy_completed => :delete}
  map.resources :users

  # root mapping
  map.root :controller => 'tasks'
  
end
