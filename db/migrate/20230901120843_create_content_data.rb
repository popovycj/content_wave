class CreateContentData < ActiveRecord::Migration[7.0]
  def change
    create_table :content_data do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :content_type, null: false, foreign_key: true
      t.jsonb :prompt
      t.string :description
      t.string :tags

      t.timestamps
    end
  end
end
