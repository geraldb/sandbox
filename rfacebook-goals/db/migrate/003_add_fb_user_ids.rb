class AddFbUserIds < ActiveRecord::Migration
  def self.up
      add_column :notes, :fb_user_id, :integer
      add_column :comments, :fb_user_id, :integer

      #if mysql
      execute("alter table notes modify fb_user_id bigint")
      execute("alter table comments modify fb_user_id bigint")
  end

  def self.down
      remove_column :notes, :fb_user_id
      remove_column :comments, :fb_user_id   
  end
end
