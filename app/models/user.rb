class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :posts, dependent: :destroy
  has_many :nfts, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :password, length: { minimum: 6 }, allow_nil: true

  # Callbacks
  before_save :normalize_email

  # Scopes
  scope :with_nfts, -> { joins(:nfts).distinct }

  private

  def normalize_email
    self.email = email.downcase.strip
  end
end
