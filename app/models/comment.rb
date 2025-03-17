class Comment < ApplicationRecord
  belongs_to :content
  belongs_to :user

  validates :body, presence: true, length: { minimum: 1, maximum: 1000 }
end
