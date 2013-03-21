ActiveAdmin.register Business do
  menu parent: "Business"

  filter :id
  filter :business_type
  filter :name
  filter :phone
  filter :address_line_1
  filter :city
  filter :state
  filter :zip
  filter :neighborhood
  filter :yelp_rating
  filter :yelp_review_count

  index do
    selectable_column
    column :id, sortable: :id do |business|
      link_to business.id, admin_business_path(business)
    end
    column :business_type, sortable: :business_type
    column :name
    column :city
    column :state
    column :zip
    column :neighborhood
    column :yelp_rating
    column :yelp_review_count

    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs "Business Details" do
      f.input :business_type
      f.input :name
      f.input :phone
      f.input :address_line_1
      f.input :address_line_2
      f.input :city
      f.input :state
      f.input :zip
      f.input :neighborhood
      f.input :categories_raw, as: :string,
              label: "Categories: separate each duty with a '|' symbol"
      f.input :yelp_id
      f.input :yelp_rating
      f.input :yelp_review_count
      f.input :image_url
    end
    f.actions
  end
end
