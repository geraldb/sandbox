class Post < ActiveRecord::Base

  belongs_to :user
  belongs_to :neighbourhood
  has_many :bookmarks
  has_many :applicants, :through => :bookmarks, :source => :user, :conditions => ['bookmarks.wants_to_be_contacted = ?', true]

  # validates_presence_of :description, :start_date, :expiry_date, :user_id
  # validates_numericality_of :rent


  def is_active?
    expiry_date >= DateTime.now
  end

  def self.active_posts()
    self.find(:all).select {|p| p.is_active? }
  end

  def has_applicants?
    !applicants.empty?
  end

end
