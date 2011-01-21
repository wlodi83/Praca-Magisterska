class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8', :force => true do |t|
      t.integer :user_id
      t.string :title
      t.text :synopsis
      t.text :body
      t.boolean :published
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :published_at
    end
  end

  def self.down
    drop_table :articles
  end
end