class AddTimeToUploadToPendingContents < ActiveRecord::Migration[7.0]
  def change
    add_column :pending_contents, :time_to_upload, :string
  end
end
