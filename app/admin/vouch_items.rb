ActiveAdmin.register VouchItem do
  filter :id
  filter :vouch_list_id, as: :numeric
  filter :business_id,   as: :numeric
  filter :description

  index do
    selectable_column
    column :id, sortable: :id do |item|
      link_to item.id, admin_vouch_item_path(item)
    end
    column :vouch_list_id, sortable: :vouch_list_id do |item|
      if item.vouch_list.present?
        link_to "Vouch List ##{item.vouch_list_id}",
                admin_vouch_list_path(item.vouch_list_id)
      end
    end
    column :business_id, sortable: :business_id do |item|
      if item.business_id.present?
        b = Business.find(item.business_id)
        link_to "Business ##{item.business_id} #{b.name}",
                admin_business_path(item.business_id)
      end
    end
    column :description

    column :created_at
    column :updated_at
    default_actions
  end

  show do
    panel "Vouch Item Details" do
      attributes_table_for vouch_item do
        row :id
        row :vouch_list_id do
          link_to "#{vouch_item.vouch_list_id}",
                  admin_vouch_list_path(vouch_item.vouch_list_id)
        end
        row :business_id do
          b = Business.find(vouch_item.business_id)
          link_to "#{vouch_item.business_id} #{b.name}",
                  admin_business_path(vouch_item.business_id)
        end
        row :description

        row :created_at
        row :updated_at
      end
    end
    active_admin_comments
  end
end
