ActiveAdmin.register SocialNetwork do
  permit_params :title, content_type_ids: []

  filter :title
  filter :content_types_id, as: :select, collection: proc { ContentType.all.map { |ct| [ct.title, ct.id] } }

  show do
    attributes_table do
      row :id
      row :title
      row "Content Types" do |social_network|
        social_network.content_types.map(&:title).join(", ")
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :content_types, as: :check_boxes
    end
    f.actions
  end
end
