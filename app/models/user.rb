class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'
  
  has_many :posts, dependent: :destroy
  
  has_many :friendships
  has_many :friends, through: :friendships, source: :friend
  has_many :received_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :received_friends, through: :received_friendships, source: 'user'
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  
  def friends_with?(user)
    Friendship.where('(user_id = ? AND friend_id = ? AND confirmed = ?) OR (user_id = ? AND friend_id = ? AND confirmed = ?)', 
                    id, user.id, true, user.id, id, true).exists?
  end
  
  def pending_friend_request_to?(user)
    friendships.where(friend: user, confirmed: false).exists?
  end
  
  def pending_friend_request_from?(user)
    inverse_friendships.where(user: user, confirmed: false).exists?
  end
  
  def friendship_status_with(other_user)
    return :self if self == other_user
    return :friends if friends_with?(other_user)
    return :pending_sent if pending_friend_request_to?(other_user)
    return :pending_received if pending_friend_request_from?(other_user)
    :not_friends
  end
  
  def find_friendship_with(user)
    Friendship.find_by('(user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)', 
                      id, user.id, user.id, id)
  end
  has_one_attached :avatar
  validates :username, presence: true, uniqueness: true
  validates :status, length: { maximum: 500 }
  has_many :posts
  has_many :likes
end
