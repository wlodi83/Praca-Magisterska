class CreateArticlesCategories < ActiveRecord::Migration
  def self.up
    create_table :articles_categories, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8', :id => false, :force => true do |t|
      t.references :category
      t.references :article
    end
    add_index :articles_categories, :article_id
    add_index :articles_categories, :category_id
    add_index :articles_categories, [:category_id, :article_id], :unique => true
  end

  def self.down
    remove_index :articles_categories, :category_id
    remove_index :articles_categories, :article_id
    remove_index :articles_categories, [:category_id, :article_id]
    drop_table :articles_categories
  end
end