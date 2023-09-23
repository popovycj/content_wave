class AddDescriptionToPendingContents < ActiveRecord::Migration[7.0]
  def change
    add_column :pending_contents, :description, :string
  end
end
