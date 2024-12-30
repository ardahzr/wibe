class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  has_many :likes, dependent: :destroy  # Adding the association
  validates :title, presence: true
  validate :content_or_media_present
  has_many :comments, dependent: :destroy
  belongs_to :user
  def liked_by?(user)
    likes.exists?(user: user)
  end

  private

  def content_or_media_present
    unless content.present? || media.attached?
      errors.add(:base, "Post must have either content or media")
    end
  end
end
