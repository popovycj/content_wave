class AddFileContentTypeToContentTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :content_types, :file_content_type, :string
  end
end
