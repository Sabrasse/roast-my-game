class Content < ApplicationRecord
  has_one_attached :media

  validates :media, presence: true
  validates :description, presence: true, length: { minimum: 10, message: "must be above 10 characters" }
end
