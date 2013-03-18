ActiveAdmin.register City do
  filter :name
  filter :display_name

  index do
    selectable_column
    column :id, sortable: :id do |city|
      link_to city.id, admin_city_path(city)
    end
    column :name
    column :display_name

    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs "City Details" do
      f.input :name
      f.input :display_name
    end
    f.actions
  end
end
