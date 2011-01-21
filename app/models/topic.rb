class Topic < ActiveRecord::Base
  attr_accessible :name, :last_poster_id, :last_post_at, :user_id, :forum_id
  belongs_to :forum
  has_many :posts, :dependent => :destroy
  belongs_to :user
end
