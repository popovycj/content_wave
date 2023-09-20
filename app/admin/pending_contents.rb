ActiveAdmin.register PendingContent do
  permit_params :chat_id, :template_id, :state, :file

  state_action :upload

  index do
    selectable_column
    id_column
    column :template
    column :state
    column :file
    actions
  end

  filter :template
  filter :state

  form do |f|
    f.inputs do
      f.input :template
      f.input :file, as: :file
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
    end
  end
end
