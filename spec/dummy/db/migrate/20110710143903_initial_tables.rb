class InitialTables < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
    end

    create_table :tasks do |t|
      t.integer :project_id
      t.string :name
    end

    create_table :milestones do |t|
      t.integer :task_id
      t.string :name
    end
  end

  def self.down
    drop_table :projects
    drop_table :tasks
    drop_table :milestones
  end
end
