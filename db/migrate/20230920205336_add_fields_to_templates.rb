class AddFieldsToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_reference :templates, :profile, foreign_key: true
    add_reference :templates, :content_type, foreign_key: true
    add_column :templates, :prompt, :jsonb
    add_column :templates, :description, :string
    add_column :templates, :tags, :string
  end
end
