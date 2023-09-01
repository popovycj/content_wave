ActiveAdmin.register Template do
  permit_params :project_id, :content_type_id, :data, :file, backgrounds: []

  filter :project
  filter :content_type

  form do |f|
    f.inputs "Template Details" do
      f.input :project
      f.input :content_type
      f.input :file, as: :file
      f.input :backgrounds, as: :file, input_html: { multiple: true }
      f.input :data
    end
    f.actions
  end

  show do
    attributes_table do
      row :project
      row :content_type
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
      row :data
    end
  end
end
