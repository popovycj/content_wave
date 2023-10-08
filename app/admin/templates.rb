ActiveAdmin.register Template do
  permit_params :title, :content_type_id, :profile_id, :data, :file, backgrounds: [], schedule_times_attributes: [:id, :day_id, :time_range_id, :_destroy]

  json_editor

  filter :title
  filter :content_type
  filter :profile

  index do
    selectable_column
    id_column
    column :title
    column :profile
    column :content_type
    column "Schedule Times" do |template|
      template.schedule_times.map do |st|
        time_range = TimeRange.find(st.time_range_id)
        "#{Day.find(st.day_id).name}: #{time_range.start_time}-#{time_range.end_time}"
      end.join(", ")
    end
    actions
  end

  form do |f|
    f.inputs "Template Details" do
      f.input :title
      f.input :content_type
      f.input :profile
      # f.input :file, as: :file
      # f.input :backgrounds, as: :file, input_html: { multiple: true }
      f.inputs "Schedule Times" do
        f.has_many :schedule_times, allow_destroy: true, new_record: true do |a|
          a.input :day_id, as: :select, collection: Day.all
          a.input :time_range_id, as: :select, collection: TimeRange.all
        end
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :content_type
      row :profile
      # row :file do |template|
      #   if template.file.attached?
      #     link_to template.file.filename, url_for(template.file)
      #   end
      # end
      # row :backgrounds do |template|
      #   ul do
      #     template.backgrounds.each do |background|
      #       li do
      #         link_to background.filename, url_for(background)
      #       end
      #     end
      #   end
      # end
      row "Schedule Times" do |template|
        ul do
          template.schedule_times.each do |st|
            time_range = TimeRange.find(st.time_range_id)
            li "#{Day.find(st.day_id).name}: #{time_range.name} (#{time_range.start_time}-#{time_range.end_time})"
          end
        end
      end
    end
  end
end
