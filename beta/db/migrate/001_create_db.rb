class CreateDb < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :company
      t.string :web
      t.string :title
      t.text   :desc
      t.string :contact
      
      t.boolean :full_time
      t.boolean :part_time
      t.boolean :contract
      
      t.string  :permalink
      t.boolean :published, :default => false

      
      t.references :category
      t.timestamps
      
      # add checkbox for full_time, part_time, contract
    end
    
    create_table :categories do |t|
      t.string :name
    end
    
    Category.create :name => 'Design'
    Category.create :name => 'Development'
    Category.create :name => 'Business/Exec'
 
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at 
  end

  def self.down
    drop_table :posts
    drop_table :categories
    drop_table :sessions
  end
end
