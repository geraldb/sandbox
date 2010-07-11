ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'jobs'

  map.tag 'tags/:tag', :controller => 'tags', :action => 'permalink'

  map.auth_accounts 'accounts/authenticate', :controller => 'accounts', :action => 'authenticate'
  map.accounts 'accounts', :controller => 'accounts', :action => 'login'

  map.jobs          'jobs',          :controller => 'jobs', :action => 'index'
  map.upcoming_jobs 'jobs/upcoming', :controller => 'jobs', :action => 'upcoming'
  map.feed_jobs     'jobs/feed',     :controller => 'jobs', :action => 'feed'

  map.new_job       'jobs/new',      :controller => 'jobs', :action => 'new'
  map.preview_job   'jobs/preview',  :controller => 'jobs', :action => 'preview' 
  map.create_job    'jobs/create',   :controller => 'jobs', :action => 'create'

  map.job 'jobs/:permalink',  :controller => 'jobs', :action => 'permalink'


  map.events        'events',          :controller => 'events', :action => 'index'
  map.new_event     'events/new',      :controller => 'events', :action => 'new'
  map.preview_event 'events/preview',  :controller => 'events', :action => 'preview'
  map.create_event  'events/create',   :controller => 'events', :action => 'create'

  map.event 'events/:permalink', :controller => 'events', :action => 'permalink'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
