class CreatePendingContents < ActiveRecord::Migration[7.0]
  def change
    create_table :pending_contents do |t|
      t.integer :chat_id
      t.references :content_datum, null: false, foreign_key: true
      t.binary :file
      t.string :state

      t.timestamps
    end
  end
end
