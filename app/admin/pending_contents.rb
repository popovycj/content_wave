ActiveAdmin.register PendingContent do
  permit_params :chat_id, :content_datum_id, :state, :file

  state_action :upload

  index do
    selectable_column
    id_column
    column :chat_id
    column :content_datum
    column :state
    column :file
    actions
  end

  filter :chat_id
  filter :content_datum
  filter :state

  form do |f|
    f.inputs do
      f.input :chat_id
      f.input :content_datum
      f.input :file, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :chat_id
      row :content_datum
      row :state
      row :file do |template|
        if template.file.attached?
          link_to template.file.filename, url_for(template.file)
        end
      end
    end
  end
end
