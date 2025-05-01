require_relative '../services/username_generator'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :generate_username, on: :create

  validates :username, presence: true, uniqueness: true

  private

  def generate_username
    return if username.present?

    loop do
      self.username = UsernameGenerator.generate
      break unless User.exists?(username: username)
    end
  end
end
