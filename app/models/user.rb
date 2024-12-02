class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'
  
  has_many :posts, dependent: :destroy
  
  validates :username, presence: true, uniqueness: true
  validates :status, length: { maximum: 500 }
end
