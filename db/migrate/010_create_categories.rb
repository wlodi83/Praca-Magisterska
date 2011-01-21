class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8', :force => true do |t|
      t.integer :parent_id, :position, :children_count, :ancestors_count, :descendants_count, :lft, :rgt
      t.boolean :hidden
      t.string :name, :description
      t.integer :articles_count, :default => 0
    end
  end
  def self.down
    drop_table :categories
  end
end

