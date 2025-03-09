class Content < ApplicationRecord
  has_one_attached :media
  has_one_attached :thumbnail

  validates :media, presence: true
  validate :acceptable_media
  validates :description, presence: true, length: { minimum: 10, maximum: 100, message: "must be between 10 and 100 characters" }

  private

  def acceptable_media
    return unless media.attached?

    # Validate file type
    acceptable_types = ["image/png", "image/jpg", "image/jpeg", "image/gif", "video/mp4", "video/webm"]
    unless acceptable_types.include?(media.content_type)
      errors.add(:media, "must be a PNG, JPG, GIF, MP4, or WebM file")
    end

    # Validate file size (Max 50MB)
    if media.byte_size > 50.megabytes
      errors.add(:media, "must be less than 50MB")
    end
  end
end
