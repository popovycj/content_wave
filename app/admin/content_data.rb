ActiveAdmin.register ContentDatum do
  config.filters = false

  permit_params :profile_id, :content_type_id, :prompt, :description, :tags#, template_attributes: [:id, :data, :file, { backgrounds: [] }, :_destroy]

  json_editor

  show do
    attributes_table do
      row :title
      row :template
      row :content_type
      row :prompt
      row :description
      row :tags
    end
  end

  form do |f|
    f.inputs do
      f.input :profile, input_html: { id: 'profile_selector' }
      if f.object.profile
        f.input :content_type, as: :select, input_html: { id: 'content_type_selector' }
      else
        f.input :content_type, as: :select, collection: [], input_html: { id: 'content_type_selector' }
      end

      # f.inputs "Template", for: [:template, f.object.template || Template.new] do |template_form|
      #   template_form.input :data, as: :jsonb
      #   template_form.input :file, as: :file
      #   template_form.input :backgrounds, as: :file, input_html: { multiple: true }
      # end

      f.input :prompt, as: :jsonb
      f.input :description, as: :string
      f.input :tags, as: :string
    end
    f.actions
  end
end
