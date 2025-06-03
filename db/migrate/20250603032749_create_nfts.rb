class CreateNfts < ActiveRecord::Migration[8.0]
  def change
    create_table :nfts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token_id
      t.string :contract_address
      t.text :metadata
      t.datetime :minted_at
      t.string :blockchain, default: 'ethereum'
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :nfts, [ :user_id, :token_id ], unique: true
    add_index :nfts, :contract_address
  end
end
