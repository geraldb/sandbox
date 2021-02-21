# encoding: UTF-8

module WineDb
  module Model

###################
# (Wine)-Family
#
#  e.g. - Red Wine
#       - White Wine
#       - Rose Wine
#       - Desert (Sweet)
#       - Sparkling (Champagne)
#       - Fortified (Brandy,Port)
#       - Other

class Family < ActiveRecord::Base

  self.table_name = 'families'
  ## to be done

end # class Family


  end # module Model
end # module WineDb
