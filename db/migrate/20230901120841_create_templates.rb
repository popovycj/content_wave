class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.references :project, null: false, foreign_key: true
      t.references :content_type, null: false, foreign_key: true
      t.binary :file
      t.binary :background
      t.jsonb :data

      t.timestamps
    end
  end
end
