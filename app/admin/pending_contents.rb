ActiveAdmin.register PendingContent do
  permit_params :chat_id, :template_id, :state, :file, :time_to_upload

  state_action :upload
  state_action :generate
  state_action :regenerate
  state_action :schedule

  index do
    selectable_column
    id_column
    column :template
    column :state
    column :file
    column :description
    column :time_to_upload
    actions
  end

  filter :template
  filter :state

  form do |f|
    f.inputs do
      f.input :template
      f.input :file, as: :file
      f.input :time_to_upload
    end
    f.actions
  end

  show do
    attributes_table do
      row :template
      row :state
      row :file do |template|
        if template.file.attached?
          link_to template.file.filename, url_for(template.file)
        end
      end
      row :description
      row :time_to_upload
    end
  end
end
