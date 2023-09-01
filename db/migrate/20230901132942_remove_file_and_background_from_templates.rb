class RemoveFileAndBackgroundFromTemplates < ActiveRecord::Migration[7.0]
  def change
    remove_column :templates, :file, :binary
    remove_column :templates, :background, :binary
  end
end
