# encoding: UTF-8

module WineDb
  module Model

class Grape < ActiveRecord::Base

  extend TextUtils::TagHelper  # will add self.find_tags, self.find_tags_in_attribs!, etc.

  # NB: use extend - is_<type>? become class methods e.g. self.is_<type>? for use in
  #   self.create_or_update_from_values
  extend TextUtils::ValueHelper  # e.g. self.is_year?, self.is_region?, self.is_address?, is_taglist? etc.

  has_many :taggings, :as => :taggable, class_name: 'WorldDb::Model::Tagging'
  has_many :tags,  :through => :taggings, class_name: 'WorldDb::Model::Tag'

  validates :key, :format => { :with => /^[a-z][a-z0-9]+$/, :message => 'expected two or more lowercase letters a-z or 0-9 digits' }


  def self.create_or_update_from_values( values, more_attribs={} )

    attribs, more_values = find_key_n_title( values )
    attribs = attribs.merge( more_attribs )
      
    # check for optional values
    Grape.create_or_update_from_attribs( attribs, more_values )
  end


  def self.create_or_update_from_attribs( attribs, values )

    # fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root
    
    value_tag_keys    = []
         
    ### check for "default" tags - that is, if present attribs[:tags] remove from hash
    value_tag_keys += find_tags_in_attribs!( attribs )

    ## check for optional values
    values.each_with_index do |value,index|
      if match_year( value ) do |num|  # founded/established year e.g. 1776
              attribs[ :since ] = num
            end
      elsif match_website( value ) do |website|  # check for url/internet address e.g. www.ottakringer.at
              attribs[ :web ] = website
            end
      elsif (values.size==(index+1)) && is_taglist?( value )  # tags must be last entry
        logger.debug "   found tags: >>#{value}<<"
        value_tag_keys += find_tags( value )
      else
        # issue warning: unknown type for value
        logger.warn "unknown type for value >#{value}< - key #{attribs[:key]}"
      end
    end # each value

    rec = Grape.find_by_key( attribs[ :key ] )

    if rec.present?
      logger.debug "update Grape #{rec.id}-#{rec.key}:"
    else
      logger.debug "create Grape:"
      rec = Grape.new
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


end # class Grape


  end # module Model
end # module WineDb
