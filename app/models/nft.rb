class Nft < ApplicationRecord
  belongs_to :user
  has_one :post, dependent: :nullify

  # Validations
  validates :title, presence: true, length: { maximum: 100 }
  validates :token_id, uniqueness: { scope: :user_id }, allow_blank: true
  validates :blockchain, inclusion: { in: %w[ethereum polygon binance] }

  # Scopes
  scope :minted, -> { where.not(minted_at: nil) }
  scope :pending, -> { where(minted_at: nil) }
  scope :by_blockchain, ->(chain) { where(blockchain: chain) }
  scope :recent, -> { order(created_at: :desc) }

  # Methods
  def minted?
    minted_at.present?
  end

  def metadata_hash
    return {} if metadata.blank?
    JSON.parse(metadata)
  rescue JSON::ParserError
    {}
  end

  def update_metadata(new_metadata)
    self.metadata = new_metadata.to_json
    save
  end
end
