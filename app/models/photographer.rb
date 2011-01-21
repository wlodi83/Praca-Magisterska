class Photographer < ActiveRecord::Base
  has_and_belongs_to_many :articles
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :within => 3..200
end
