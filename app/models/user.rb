class User < ApplicationRecord
  include PublicActivity::Model
	tracked owner: ->(controller, model) { 
    controller && controller.current_user 
  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_voter

  devise :database_authenticatable, 
         :registerable, 
         :recoverable, 
         :rememberable, 
         :validatable

  validates :username, presence: true
  validates :username, uniqueness: true

  has_many :examples
  has_many :phrases

  extend FriendlyId
  friendly_id :username, use: :slugged

  def has_new_notifications?
    PublicActivity::Activity.where(recipient_id: self.id, readed: false).any?
  end
end
