class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.references :nft, null: true, foreign_key: true
      t.string :status, default: 'pending' # pending, minting, minted, failed

      t.timestamps
    end

    add_index :posts, :status
    add_index :posts, :created_at
  end
end
