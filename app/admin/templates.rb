ActiveAdmin.register Template do
  permit_params :title, :content_type_id, :profile_id, :data, :file, backgrounds: []

  json_editor

  filter :title

  form do |f|
    f.inputs "Template Details" do
      f.input :title
      f.input :content_type
      f.input :profile
      f.input :file, as: :file
      f.input :backgrounds, as: :file, input_html: { multiple: true }
      f.input :data, as: :jsonb
      f.input :description
      f.input :tags
      f.input :prompt
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :content_type
      row :profile
      row :file do |template|
        if template.file.attached?
          link_to template.file.filename, url_for(template.file)
        end
      end
      row :backgrounds do |template|
        ul do
          template.backgrounds.each do |background|
            li do
              link_to background.filename, url_for(background)
            end
          end
        end
      end
      row :data, as: :jsonb
      row :description
      row :tags
      row :prompt
    end
  end
end
