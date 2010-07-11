class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.text   :desc

      t.string  :permalink
      t.boolean :published, :default => false
      t.boolean :featured,  :default => false

      t.references :gcategory
      t.timestamps
    end

    create_table :services do |t|
      t.references :group
      t.references :scategory
      t.string     :link
      t.timestamps
    end

    create_table :scategories do |t|
      t.string :name
    end
    
    Scategory.create :name => 'Site'
    Scategory.create :name => 'Forum'
    Scategory.create :name => 'Jobs'
    Scategory.create :name => 'Planet'
    Scategory.create :name => 'Facebook'
    Scategory.create :name => 'Meetup'
    
    create_table :gcategories do |t|
      t.string :name
    end
    
    Gcategory.create :name => 'Development'
    Gcategory.create :name => 'Design'
    Gcategory.create :name => 'Q&A'
    Gcategory.create :name => 'Methodology'
    Gcategory.create :name => 'Net Neutrality/Wireless'
    Gcategory.create :name => 'Computer'
    Gcategory.create :name => 'Recycling / Education / Empowerment'
    Gcategory.create :name => 'Communication'
    Gcategory.create :name => 'Networking'
    Gcategory.create :name => 'Demos & Unconferences'  
  end

  def self.down
    drop_table :groups
    drop_table :services
    drop_table :gcategories
    drop_table :scategories
  end
end
