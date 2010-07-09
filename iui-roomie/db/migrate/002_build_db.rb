class BuildDb < ActiveRecord::Migration
  def self.up

    create_table :neighbourhoods do |t|
      t.string :name, :area

      t.timestamps
    end

    create_table :posts do |t|
      t.references :user, :neighbourhood
      t.integer :rent
      t.date :start_date, :expiry_date
      t.boolean :includes_utilities
      t.string :description

      t.timestamps
    end

    create_table :bookmarks do |t|
      t.references :user, :post
      t.string :note
      t.boolean :wants_to_be_contacted, :default => false

      t.timestamps
    end

  end

  def self.down
    drop_table :neighbourhoods
    drop_table :posts
    drop_table :bookmarks
  end
end
