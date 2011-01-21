class Role < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :within => 3..20
  acts_as_authorization_role
  has_and_belongs_to_many :users
end