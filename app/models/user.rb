class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+[a-zA-Z0-9-]+@[a-zA-Z0-9-]+[a-z\d\-.]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  private

  def downcase_email
    self.email = email.downcase
  end
end
