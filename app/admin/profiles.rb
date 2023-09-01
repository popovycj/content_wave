ActiveAdmin.register Profile do
  permit_params :project_id, :social_network_id, :auth_data
end
