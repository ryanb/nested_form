class InitialTables < ActiveRecord::Migration
  def up
    create_table :projects, :force => true do |t|
      t.string :name
    end

    create_table :tasks, :force => true do |t|
      t.integer :project_id
      t.string :name
    end

    create_table :milestones, :force => true do |t|
      t.integer :task_id
      t.string :name
    end
  end

  def down
    drop_table :projects
    drop_table :tasks
    drop_table :milestones
  end
end
