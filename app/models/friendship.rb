class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  
  validates :user_id, uniqueness: { scope: :friend_id }
  validate :not_self
  
  def pending?
    !confirmed
  end
  
  def accepted?
    confirmed
  end
  
  private
  
  def not_self
    errors.add(:friend, "can't be yourself") if user == friend
  end
end