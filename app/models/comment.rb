class Comment < ApplicationRecord
  belongs_to :content
  belongs_to :user, optional: true

  validates :body, presence: true, length: { minimum: 1, maximum: 1000 }
  validates :guest_name, presence: true, if: -> { user.nil? }
  validates :guest_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true, if: -> { user.nil? }
  validates :ip_address, presence: true, if: -> { user.nil? }

  before_validation :set_ip_address, if: -> { user.nil? }

  private

  def set_ip_address
    self.ip_address = Current.ip_address
  end
end
