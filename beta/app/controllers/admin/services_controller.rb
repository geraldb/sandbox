class Admin::ServicesController < ApplicationController

  layout 'admin'
  before_filter :admin_required

  active_scaffold :service do |config|
    config.label = "Services"
    config.list.per_page = 25
    config.list.sorting = {:created_at => 'DESC'}
    
    config.columns = [:scategory, :link, :group]
    config.columns[:scategory].label = 'Category'   
  end

end
