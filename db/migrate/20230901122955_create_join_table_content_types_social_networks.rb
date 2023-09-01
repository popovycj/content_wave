class CreateJoinTableContentTypesSocialNetworks < ActiveRecord::Migration[6.1]
  def change
    create_join_table :content_types, :social_networks do |t|
      t.index [:content_type_id, :social_network_id], name: 'index_ct_sn'
      t.index [:social_network_id, :content_type_id], name: 'index_sn_ct'
    end
  end
end
