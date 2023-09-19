class AddTitleToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :title, :string
  end
end
