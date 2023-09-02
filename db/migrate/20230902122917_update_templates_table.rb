class UpdateTemplatesTable < ActiveRecord::Migration[7.0]
  def change
    # Remove foreign keys and indexes related to content_type and project
    remove_foreign_key :templates, :content_types
    remove_foreign_key :templates, :projects

    # Remove the columns related to content_type and project
    remove_column :templates, :content_type_id, :integer
    remove_column :templates, :project_id, :integer

    # Add a new foreign key column pointing to content_data
    add_column :templates, :content_datum_id, :integer, null: false, default: 1

    # Add foreign key constraint and index
    add_foreign_key :templates, :content_data, column: :content_datum_id
    add_index :templates, :content_datum_id, unique: true
  end
end
