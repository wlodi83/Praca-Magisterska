class Category < ActiveRecord::Base
  has_and_belongs_to_many :articles,
                          :after_add => :counter_inc,
                          :after_remove => :counter_dec

  def counter_inc(t)
    t.counter_inc(self)
  end

  def counter_dec(t)
    t.counter_dec(self)
  end

  validates_presence_of :name, :description
  validates_length_of :name, :within => 3..200
  validates_length_of :description, :within => 3..500

  validate :uniqueness_name_of_category
  def uniqueness_name_of_category
    if Category.count(:conditions => ["name = ? and parent_id is null", name]) > 0
      errors.add(:name, "Istnieje już kategoria o podanej nazwie w bazie danych")
    end
  end
  validates_inclusion_of :hidden, :in => [true, false],
    :message => "Musisz zaznaczyć opcję czy kategoria ma być ukryta"

  acts_as_category 
  acts_as_nested_set
end