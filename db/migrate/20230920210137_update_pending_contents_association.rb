class UpdatePendingContentsAssociation < ActiveRecord::Migration[7.0]
  def change
     add_reference :pending_contents, :template, foreign_key: true
     remove_reference :pending_contents, :content_datum
  end
end
