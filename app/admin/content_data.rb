ActiveAdmin.register ContentDatum do
  permit_params :profile_id, :content_type_id, :prompt, :description, :tags

  form do |f|
    f.inputs do
      f.input :profile, input_html: { id: 'profile_selector' }
      f.input :content_type, as: :select, collection: [], input_html: { id: 'content_type_selector' }

      f.input :prompt, as: :string
      f.input :description, as: :string
      f.input :tags, as: :string
    end
    f.actions
  end
end
