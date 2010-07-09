ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'

  map.resources :users, :has_many => [:bookmarks, :posts]
  map.resources :sessions
  map.resources :bookmarks
  map.resources :posts, :has_many => [:bookmarks, :applicants], :has_one => :neighbourhood,
         :collection => {:search => :post}
  map.resources :neighbourhoods, :has_many => :posts

  map.welcome '/welcome', :controller => 'home', :action => 'welcome'

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'


  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
