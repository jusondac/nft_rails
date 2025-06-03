class Post < ApplicationRecord
  belongs_to :user
  belongs_to :nft, optional: true

  # Active Storage for image attachment
  has_one_attached :image

  # Validations
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :status, inclusion: { in: %w[pending minting minted failed] }
  validates :image, presence: true, on: :create

  # Scopes
  scope :minted, -> { where(status: "minted") }
  scope :pending_mint, -> { where(status: "pending") }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  after_create :initiate_minting_process

  # Methods
  def minted?
    status == "minted" && nft.present?
  end

  def can_mint?
    status == "pending" && image.attached?
  end

  def image_url
    return nil unless image.attached?
    Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  end

  private

  def initiate_minting_process
    MintNftJob.perform_later(self) if can_mint?
  end
end
