class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :description
      t.references :article, :user
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end