module ActiveRecord
  
  # strip id from errors so select gets wrapped into a div.error
  #   without id stripping it won't work
  # monkey patch copied from @ http://wiki.rubyonrails.org/rails/pages/HowtoChangeValidationErrorDisplay
  
  class Errors
    alias_method :on_without_id_stripping, :on
    def on(attribute)
      on_without_id_stripping(attribute.to_s.sub(/_id$/, ''))
    end
  end
end

require 'date'

module Week
  def week
    (yday + 7 - wday) / 7
  end
end

class Date
  include Week
end

class Time
  include Week
end
