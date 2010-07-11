class Admin::GcategoriesController < ApplicationController

  layout 'admin'
  before_filter :admin_required

  active_scaffold :gcategory do |config|
    config.label = "Categories (Groups)"
    config.list.per_page = 25
  end

end
