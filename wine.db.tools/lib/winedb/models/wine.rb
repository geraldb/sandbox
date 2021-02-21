# encoding: UTF-8

module WineDb
  module Model

class Wine < ActiveRecord::Base

  extend TextUtils::TagHelper  # will add self.find_tags, self.find_tags_in_attribs!, etc.

  # NB: use extend - is_<type>? become class methods e.g. self.is_<type>? for use in
  #   self.create_or_update_from_values
  extend TextUtils::ValueHelper  # e.g. self.is_year?, self.is_region?, self.is_address?, is_taglist? etc.

  belongs_to :country,  class_name: 'WorldDb::Model::Country', foreign_key: 'country_id'
  belongs_to :region,   class_name: 'WorldDb::Model::Region',  foreign_key: 'region_id'
  belongs_to :city,     class_name: 'WorldDb::Model::City',    foreign_key: 'city_id'
  belongs_to :vineyard, class_name: 'WineDb::Model::Vineyard', foreign_key: 'vinyard_id'

  belongs_to :winery, :class_name => 'WineDb::Model::Winery', foreign_key: 'winery_id'

  has_many :taggings, :as => :taggable, class_name: 'WorldDb::Model::Tagging'
  has_many :tags,  :through => :taggings, class_name: 'WorldDb::Model::Tag'

  validates :key, :format => { :with => /^[a-z][a-z0-9]+$/, :message => 'expected two or more lowercase letters a-z or 0-9 digits' }



  def self.create_or_update_from_values( values, more_attribs={} )

    attribs, more_values = find_key_n_title( values )
    attribs = attribs.merge( more_attribs )
      
    # check for optional values
    Wine.create_or_update_from_attribs( attribs, more_values )
  end


  def self.create_or_update_from_attribs( attribs, values )

    # fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root
    
    value_tag_keys    = []
         
    ### check for "default" tags - that is, if present attribs[:tags] remove from hash
    value_tag_keys += find_tags_in_attribs!( attribs )
    
    ## check for optional values
    values.each_with_index do |value,index|
      if match_country(value) do |country|
           attribs[ :country_id ] = country.id
         end
      elsif match_region_for_country(value, attribs[:country_id]) do |region|
              attribs[ :region_id ] = region.id
            end
      elsif match_city(value) do |city|
              if city.present?
                attribs[ :city_id ] = city.id
              else
                ## todo/fix: add strict mode flag - fail w/ exit 1 in strict mode
                logger.warn "city with key #{value[5..-1]} missing for beer #{attribs[:key]}"
              end
            end
      elsif match_year( value ) do |num|  # founded/established year e.g. 1776
              attribs[ :since ] = num
            end
      elsif match_website( value ) do |website|  # check for url/internet address e.g. www.ottakringer.at
              attribs[ :web ] = website
            end
      elsif value =~ /^winery:/   ## winery:<key> e.g. winery:antonbauer
        winery_key = value[7..-1].strip  ## cut off by: prefix
        winery = Winery.find_by_key!( winery_key )
        attribs[ :winery_id ] = winery.id


# -- todo/fix: move to vintage (that is, abv depends on year)
#      elsif match_abv( value ) do |num|   # abv (alcohol by volume)
#              # nb: also allows leading < e.g. <0.5%
#              attribs[ :abv ] = num
#            end
      elsif (values.size==(index+1)) && is_taglist?( value )  # tags must be last entry
        logger.debug "   found tags: >>#{value}<<"
        value_tag_keys += find_tags( value )
      else
        # issue warning: unknown type for value
        logger.warn "unknown type for value >#{value}< - key #{attribs[:key]}"
      end
    end # each value

    #  rec = Wine.find_by_key_and_country_id( attribs[ :key ], attribs[ :country_id] )
    rec = Wine.find_by_key( attribs[ :key ] )

    if rec.present?
      logger.debug "update Wine #{rec.id}-#{rec.key}:"
    else
      logger.debug "create Wine:"
      rec = Wine.new
    end
      
    logger.debug attribs.to_json

    rec.update_attributes!( attribs )

    ##################
    # add taggings 

    if value_tag_keys.size > 0
        
        value_tag_keys.uniq!  # remove duplicates
        logger.debug "   adding #{value_tag_keys.size} taggings: >>#{value_tag_keys.join('|')}<<..."

        ### fix/todo: check tag_ids and only update diff (add/remove ids)

        value_tag_keys.each do |key|
          tag = Tag.find_by_key( key )
          if tag.nil?  # create tag if it doesn't exit
            logger.debug "   creating tag >#{key}<"
            tag = Tag.create!( key: key )
          end
          rec.tags << tag
        end
    end
    
    rec # NB: return created or updated obj

  end # method create_or_update_from_values

end # class Wine

  end # module Model
end # module WineDb
