class Phrase < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { 
    controller && controller.current_user 
  }
  
  include SharedMethods

  acts_as_votable

  validates :phrase, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :translation, presence: true, length: { maximum: 30 }
  validates :category, inclusion: {
    in: %w(Actions Time Productivity Apologies Common),
  	message: "%{value} is not a valid categoty"
  }

  enum category: ['Actions', 'Time', 'Productivity', 'Apologies', 'Common']

  belongs_to :user
  has_many :examples, dependent: :destroy

  accepts_nested_attributes_for :examples, allow_destroy: true

  default_scope { order(vote_weight: :desc) }
  def author?(user)
  	self.user == user
  end
	
  extend FriendlyId
  friendly_id :phrase, use: :slugged
end

