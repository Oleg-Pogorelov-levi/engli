class Example < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { 
    controller && controller.current_user 
  }
  
  include SharedMethods

  acts_as_votable

  belongs_to :phrase
  belongs_to :user

  validates :example, :user_id, presence: true
  validates :example, uniqueness: true, length: { maximum: 250 }
end
