class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string  :title
      t.string  :venue
      t.string  :address
      t.date    :occurs_on
      t.time    :start_time
      # t.boolean :all_day
      t.string  :web
      t.text    :desc

      t.string  :permalink
      t.boolean :published, :default => false


      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
