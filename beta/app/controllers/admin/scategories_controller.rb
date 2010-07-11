class Admin::ScategoriesController < ApplicationController

  layout 'admin'
  before_filter :admin_required

  active_scaffold :scategory do |config|
    config.label = "Categories (Services)"
    config.list.per_page = 25    
  end

end
