class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  validates_presence_of :nick, :title, :comment
  validates_length_of :title, :within => 3..50
  validates_length_of :nick, :within => 3..50
  validates_length_of :comment, :within => 3..1000
end