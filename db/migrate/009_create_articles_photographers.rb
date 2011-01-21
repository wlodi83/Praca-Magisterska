class CreateArticlesPhotographers < ActiveRecord::Migration
    def self.up
    create_table :articles_photographers, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8', :id => false, :force => true do |t|
      t.references :article
      t.references :photographer
    end
  end

  def self.down
    drop_table :articles_photographers
  end
end
