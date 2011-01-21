class Article < ActiveRecord::Base
  has_many :comment
  before_save :update_published_at
  belongs_to :user
  has_many :photos, :dependent => :destroy
  has_and_belongs_to_many :categories,
                          :after_add => :counter_inc,
                          :after_remove => :counter_dec
  def counter_inc(t)
    counter_change(t, 1)
  end

  def counter_dec(t)
    counter_change(t, -1)
  end

  acts_as_commentable
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :photographers
  define_index do
    # fields
    indexes title
    indexes body
    indexes synopsis
    indexes authors.name, :as => :authors_name
    indexes photographers.name, :as => :photographers_name
    indexes categories.name, :as => :categories_name
    # attributes
    has authors(:id), :as => :author_ids
    has photographers(:id), :as => :photographer_ids
    has categories(:id), :as => :category_ids
    
    has created_at, updated_at
  end
  #walidacje
  validates_presence_of :title, :synopsis, :body
  validates_inclusion_of :published, :in => [true, false], :message => "Musisz zaznaczyć opcję czy artykuł ma być opublikowany"
  validates_presence_of :user_id
  validates_length_of :title, :within => 3..200
  validates_length_of :synopsis, :maximum => 50000
  validates_length_of :body, :maximum => 500000

  validate :maximum_three_categories
  validate :minimum_one_category
  validate :minimum_one_author
  
  def minimum_one_category
    errors.add(:categories, "Musisz zaznaczyć conajmniej jedną kategorię") if (categories.length < 1)
  end

  def maximum_three_categories
    errors.add(:categories, "Możesz zaznaczyć maksimum 3 kategorie") if (categories.length > 3)
  end

  def minimum_one_author
   errors.add(:authors, "Musisz zaznaczyć conajmniej jednego Autora tekstu") if (authors.length < 1)
  end

  def update_published_at
    self.published_at = Time.now if published == true
  end
  
  private

  def counter_change(object, amount)
    object.articles_count = object.articles_count+amount;
    object.save
  end
  
end
