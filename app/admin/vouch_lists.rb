ActiveAdmin.register VouchList do
  menu parent: "Vouch"

  filter :id
  filter :owner_id, as: :numeric
  filter :city_id,   as: :numeric
  filter :title
  filter :status

  index do
    selectable_column
    column :id, sortable: :id do |list|
      link_to list.id, admin_vouch_list_path(list)
    end
    column :owner_id, sortable: :owner_id do |list|
      if list.owner_id.present?
        link_to "Owner ##{list.owner_id}",
                admin_user_path(list.owner_id)
      end
    end
    column :city_id, sortable: :city_id do |list|
      if list.city_id.present?
        link_to "City ##{list.city.id} #{list.city.name}",
                admin_city_path(list.city)
      end
    end
    column :title
    column :status

    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs "Vouch list Details" do
      f.input :owner_id, as: :select, collection: User.all.map(&:id)
      f.input :city_id, as: :select, collection: City.all.map(&:id)
      f.input :title
      f.input :description
      f.input :status
    end
    f.actions
  end
end
