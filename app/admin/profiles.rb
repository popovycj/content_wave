ActiveAdmin.register Profile do
  permit_params :project_id, :social_network_id, :auth_data

  json_editor

  form do |f|
    f.inputs do
      f.input :project
      f.input :social_network
      f.input :auth_data, as: :jsonb
    end
    f.actions
  end
end
