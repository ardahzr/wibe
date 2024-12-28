# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_one_attached :attachment

  validates :body, presence: true, unless: -> { attachment.attached? }
  
  def image?
    attachment.content_type.start_with?('image/') if attachment.attached?
  end
end
