class Content < ApplicationRecord
  # Make user association optional
  belongs_to :user, optional: true, touch: true
  has_one_attached :media
  has_one_attached :thumbnail
  has_many :comments, dependent: :destroy

  # Add session token for anonymous uploads
  attribute :session_token, :string

  # This tells Rails to automatically update cache keys when the record changes
  # It's needed for the cache(["v1", content]) to work properly
  include ActionView::RecordIdentifier

  # Generate thumbnails for both images and videos
  after_create_commit :generate_thumbnail

  # This will update the cache when the media attachment changes
  has_one_attached :media do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
  end

  # Validations
  validates :media, presence: true
  validate :acceptable_media
  validates :description, presence: true, length: { minimum: 10, maximum: 500, message: "must be between 10 and 500 characters" }

  # Scopes
  scope :anonymous, -> { where(user_id: nil) }
  scope :registered, -> { where.not(user_id: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :expiring_soon, -> { anonymous.where('created_at < ?', 7.days.ago) }

  def thumbnail_url
    Rails.logger.info "Content ##{id}: Generating thumbnail_url"
    Rails.logger.info "Content ##{id}: thumbnail attached? #{thumbnail.attached?}"
    Rails.logger.info "Content ##{id}: media attached? #{media.attached?}"
    Rails.logger.info "Content ##{id}: media content type: #{media.content_type}" if media.attached?

    return url_for(thumbnail) if thumbnail.attached?
    return url_for(media.variant(:thumb)) if media.attached? && media.content_type.start_with?('image/')
    return url_for(media.preview(resize_to_limit: [300, 300])) if media.attached? && media.content_type.start_with?('video/')
    nil
  end

  private

  def generate_thumbnail
    Rails.logger.info "Content ##{id}: Starting thumbnail generation"
    return unless media.attached?

    Rails.logger.info "Content ##{id}: Media is attached, content type: #{media.content_type}"
    
    begin
      if media.content_type.start_with?('image/')
        Rails.logger.info "Content ##{id}: Generating image thumbnail"
        thumbnail.attach(
          media.variant(resize_to_limit: [300, 300]).processed
        )
        Rails.logger.info "Content ##{id}: Image thumbnail generated successfully"
      elsif media.content_type.start_with?('video/')
        Rails.logger.info "Content ##{id}: Generating video thumbnail"
        preview = media.preview(resize_to_limit: [300, 300])
        Rails.logger.info "Content ##{id}: Video preview generated, attaching thumbnail"
        thumbnail.attach(preview.processed)
        Rails.logger.info "Content ##{id}: Video thumbnail attached successfully"
      end
    rescue => e
      Rails.logger.error "Content ##{id}: Error generating thumbnail: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

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

  # Only generate cache keys for registered users' content
  def cache_key_with_version
    if user_id.present?
      "#{super}-#{user.cache_key_with_version}"
    else
      super
    end
  end
end
