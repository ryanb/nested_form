class AddAssociationWithClassName < ActiveRecord::Migration
  def self.up
    create_table :project_tasks do |t|
      t.integer :project_id
      t.string :name
    end
  end

  def self.down
    drop_table :project_tasks
  end
end
