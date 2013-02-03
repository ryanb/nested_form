class CreateCompany < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
    end

    add_column :projects, :company_id, :integer
  end

  def self.down
    remove_column :projects, :company_id
    drop_table :companies
  end
end
