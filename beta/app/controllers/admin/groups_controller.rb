class Admin::GroupsController < ApplicationController

  layout 'admin'
  before_filter :admin_required

  active_scaffold :group do |config|
    config.label = 'Groups'
    config.list.per_page = 25
    config.list.sorting = {:created_at => 'DESC'}
    
    # todo add :tags?
    config.columns = [:name, :desc, :permalink, :published, :featured, :gcategory, :services]
    config.list.columns.exclude :permalink

    config.columns[:gcategory].label = 'Category' 
  end

end
