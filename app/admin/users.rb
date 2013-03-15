ActiveAdmin.register User do
  # Override update method so we can allow updates without passwords
  controller do
    def update
      @user = User.find(params[:id])
      if params[:user][:password].blank?
        @user.update_without_password(params[:user])
      else
        @user.update_attributes(params[:user])
      end

      if @user.errors.blank?
        redirect_to admin_users_path, :notice => "User updated successfully."
      else
        render :edit
      end
    end
  end

  filter :id
  filter :email
  filter :first_name
  filter :last_name
  filter :admin
  filter :city_id

  index do
    selectable_column
    column :id, sortable: :id do |user|
      link_to user.id, admin_user_path(user)
    end
    column :email
    column :first_name
    column :last_name
    column :admin
    column :city_id

    column :created_at
    column :updated_at
    default_actions
  end

  show do
    panel "User Details" do
      attributes_table_for user do
        row :id
        row :email
        row :first_name
        row :last_name
        row :admin
        row :city_id
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :password
      f.input :password_confirmation
      f.input :admin
      f.input :city_id, as: :select, collection: City.all.map(&:id)
    end
    # f.buttons 
    f.actions
  end
end
