class RemoveFieldsFromTemplates < ActiveRecord::Migration[7.0]
  def change
    remove_column :templates, :data, :jsonb
    remove_column :templates, :prompt, :jsonb
    remove_column :templates, :description, :string
    remove_column :templates, :tags, :string
  end
end
