class CreateArticlesAuthors < ActiveRecord::Migration
  def self.up
    create_table :articles_authors, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8', :id => false, :force => true do |t|
      t.references :article
      t.references :author
    end
  end

  def self.down
    drop_table :articles_authors
  end
end
