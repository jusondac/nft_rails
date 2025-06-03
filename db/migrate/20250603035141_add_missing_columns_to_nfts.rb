class AddMissingColumnsToNfts < ActiveRecord::Migration[8.0]
  def change
    add_column :nfts, :name, :string
    add_column :nfts, :image_url, :string
    add_column :nfts, :blockchain_network, :string
    add_column :nfts, :mint_transaction_hash, :string
    add_column :nfts, :minting_status, :string
  end
end
