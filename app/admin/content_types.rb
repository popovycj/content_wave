ActiveAdmin.register ContentType do
  permit_params :title, :file_content_type, social_network_ids: []

  filter :title
  filter :file_content_type, as: :select, collection: ContentType.file_content_types
  filter :social_networks_id, as: :select, collection: proc { SocialNetwork.all.map { |sn| [sn.title, sn.id] } }

  index do
    selectable_column
    id_column
    column :title
    column :file_content_type
    actions
  end


  show do
    attributes_table do
      row :id
      row :title
      row :file_content_type
      row "Social Networks" do |content_type|
        content_type.social_networks.map(&:title).join(", ")
      end
    end
  end


  form do |f|
    f.inputs do
      f.input :title
      f.input :file_content_type, as: :select, collection: ContentType.file_content_types
      f.input :social_networks, as: :check_boxes
    end
    f.actions
  end
end
