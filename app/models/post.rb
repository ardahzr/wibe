class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  validates :title, presence: true
  validate :content_or_media_present

  private

  def content_or_media_present
    unless content.present? || media.attached?
      errors.add(:base, "Post must have either content or media")
    end
  end
end