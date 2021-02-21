# encoding: UTF-8

module WineDb
  module Model

class Winery < ActiveRecord::Base

  extend TextUtils::TagHelper  # will add self.find_tags, self.find_tags_in_attribs!, etc.

  # NB: use extend - is_<type>? become class methods e.g. self.is_<type>? for use in
  #   self.create_or_update_from_values
  extend TextUtils::ValueHelper  # e.g. self.is_year?, self.is_region?, is_address?, is_taglist? etc.
  extend TextUtils::AddressHelper  # e.g self.normalize_addr, self.find_city_in_addr, etc.

  self.table_name = 'wineries'

  belongs_to :country, class_name: 'WorldDb::Model::Country', foreign_key: 'country_id'
  belongs_to :region,  class_name: 'WorldDb::Model::Region',  foreign_key: 'region_id'
  belongs_to :city,    class_name: 'WorldDb::Model::City',    foreign_key: 'city_id'

  has_one    :tavern,  class_name: 'WineDb::Model::Tavern',  foreign_key: 'tavern_id'
  has_many   :wines,   class_name: 'WineDb::Model::Wine',    foreign_key: 'wine_id'

  has_many :taggings, :as => :taggable,   class_name: 'WorldDb::Model::Tagging'
  has_many :tags,  :through => :taggings, class_name: 'WorldDb::Model::Tag'

  validates :key, :format => { :with => /^[a-z][a-z0-9]+$/, :message => 'expected two or more lowercase letters a-z or 0-9 digits' }


  def self.create_or_update_from_values( values, more_attribs={} )
    attribs, more_values = find_key_n_title( values )
    attribs = attribs.merge( more_attribs )

    # check for optional values
    Winery.create_or_update_from_attribs( attribs, more_values )
  end


  def self.create_or_update_from_attribs( new_attributes, values )

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root

    value_tag_keys    = []

    ## check for grades (e.g. ***/**/*) in titles (will add new_attributes[:grade] to hash)
    ## if grade missing; set default to 4; lets us update overwrite 1,2,3 values on update
    new_attributes[ :grade ] ||= 4
    
    ####
    ## check if :title or :synonyms includes person name e.g.  ends w/ (????)
    ##   patch and auto-add person
    ###  --todo/fix: move code into find_key_n_title (for reuse!!!) !!!!!!

    titles  = [ new_attributes[:title] ]
    titles += new_attributes[:synonyms].split('|')  if new_attributes[:synonyms]

    persons = []

    titles = titles.map do |title_raw|
      title = title_raw.strip
      ### todo: add support for name synonyms e.g. separated by * ascii or <bullet>
      if title =~ /\s+\([\d?]{4}\)$/   ## -- allow (19??) or (????) or (2100) etc.
        logger.debug "  found person >#{title}< in title"
        ### cut-off year
        person_name = title[0...-6].strip   ## cut-off enclosed year and spaces
        person_year = $1.to_s
        ## todo: year if person_year is all digits ? if not use nil

        persons << [person_name, person_year]
        person_name  # note: return person_name as new title (that is, title w/ year cut-off)
      else
        title # pass through as is
      end
    end

    new_attributes[:title]    = titles[0]
    new_attributes[:synonyms] = titles[1..-1].join('|')  if titles.size > 1



    ### check for "default" tags - that is, if present new_attributes[:tags] remove from hash
    value_tag_keys += find_tags_in_attribs!( new_attributes )

    ## check for optional values
    values.each_with_index do |value,index|
      if match_country(value) do |country|
           new_attributes[ :country_id ] = country.id
         end
      elsif match_region_for_country(value,new_attributes[:country_id]) do |region|
              new_attributes[ :region_id ] = region.id
            end
      elsif match_city(value) do |city|
              if city.present?
                new_attributes[ :city_id ] = city.id
              else
                ## todo/fix: add strict mode flag - fail w/ exit 1 in strict mode
                logger.warn "city with key #{value[5..-1]} missing - for winery #{new_attributes[:key]}"
              end

              ## for easy queries: cache region_id (from city)
              #  - check if city w/ region if yes, use it for winery too
              if city.present? && city.region.present?
                new_attributes[ :region_id ] = city.region.id
              end
            end
      elsif match_year( value ) do |num|  # founded/established year e.g. 1776
              new_attributes[ :since ] = num
            end
      elsif match_website( value ) do |website|  # check for url/internet address e.g. www.ottakringer.at
              # fix: support more url format (e.g. w/o www. - look for .com .country code etc.)
              new_attributes[ :web ] = website
            end
      elsif is_address?( value ) # if value includes // assume address e.g. 3970 Weitra // Sparkasseplatz 160
        new_attributes[ :address ] = normalize_addr( value )
      elsif value =~ /^(\?+|[0-9_]+)\s*ha$/  # e.g. 12 ha or 12ha or 2_000 ha ??? ha etc.
        logger.debug "   skipping area (in ha) for now >#{value}<"
      elsif value =~ /^(\?+|[0-9_]+)\s*hl$/  # e.g. 50000 hl or 50_000 hl etc.
        logger.debug "   skipping prod (in hl) for now >#{value}<"
      elsif (values.size==(index+1)) && is_taglist?( value ) # tags must be last entry
        ### fix: is_taglist?
        ##  do NOT match   24 ha  or 50000 hl etc. - check e.g. leading number not allowed etc.
        logger.debug "   found tags: >>#{value}<<"
        value_tag_keys += find_tags( value )
      else
        # issue warning: unknown type for value
        logger.warn "unknown type for value >#{value}< - key #{new_attributes[:key]}"
      end
    end # each value

    ## todo: check better style using self.find_by_key?? why? why not?
    rec = Winery.find_by_key( new_attributes[ :key ] )

    if rec.present?
      logger.debug "update Winery #{rec.id}-#{rec.key}:"
    else
      logger.debug "create Winery:"
      rec = Winery.new
    end

    logger.debug new_attributes.to_json

    rec.update_attributes!( new_attributes )


    #################################
    # auto-add person if present
    
    if persons.size > 0
      persons.each do |person|

        person_name = person[0]
        person_key  = TextUtils.title_to_key( person_name )

        person_attributes = {
          name: person_name
        }

        person_rec = Person.find_by_key( person_key )
        if person_rec.present?
          logger.debug "  auto-update Person #{person_rec.id}-#{person_rec.key}:"
        else
          logger.debug "  auto-create Person:"
          person_rec =Person.new
          person_attributes[ :key ] = person_key
        end

        logger.debug person_attributes.to_json

        person_rec.update_attributes!( person_attributes )

        ## todo: add winery_id reference to person !!!!
        ### add person_id reference to winery!!!
      end
    end


    ##############################
    # auto-add city if not present and country n region present
    
    if new_attributes[:city_id].blank? &&
       new_attributes[:country_id].present? &&
       new_attributes[:region_id].present?
       
      country_key = rec.country.key

      if country_key == 'at' || country_key == 'de'

        ## todo: how to handle nil/empty address lines?

        city_title = find_city_in_addr( new_attributes[:address], country_key )
        
        if city_title.present?
          
          city_values = [city_title]
          city_attributes = {
            country_id: rec.country_id,
            region_id:  rec.region_id
          }
          # todo: add convenience helper create_or_update_from_title
          city = City.create_or_update_from_values( city_values, city_attributes )

          ### fix/todo: set new autoadd flag too?
          ##  e.g. check if updated? e.g. timestamp created <> updated otherwise assume created?

          ## now at last add city_id to winery!
          rec.city_id = city.id
          rec.save!
        else
          logger.warn "auto-add city for #{new_attributes[:key]} (#{country_key}) >>#{new_attributes[:address]}<< failed; no city title found"
        end
      end
    end

    ##################
    ## add taggings

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


end # class Winery

  end # module Model
end # module WineDb
