class RemoveContentData < ActiveRecord::Migration[7.0]
  def change
    remove_reference :templates, :content_datum
    drop_table :content_data
  end
end
