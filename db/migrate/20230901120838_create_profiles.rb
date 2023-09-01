class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :project, null: false, foreign_key: true
      t.references :social_network, null: false, foreign_key: true
      t.json :auth_data

      t.timestamps
    end
  end
end
