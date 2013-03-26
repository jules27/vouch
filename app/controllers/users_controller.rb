class UsersController < ApplicationController
  def lookup
    # Lookup by email address
    user = User.find_by_email(params[:email])
    unless user.present?
      render json: { errors: "User with email #{params[:email]} does not exist." }
      return
    end

    # You cannot be friends with yourself
    if params[:email] == current_user.email
      render json: { errors: "You cannot be friends with yourself :)" }
      return
    end

    # Are they friends already?
    if current_user.friends_with?(user)
      render json: { errors: "You are already friends with #{user.name}." }
      return
    end

    # Create friendship for current user
    friendship = Friendship.create(user_id: current_user.id,
                                   friend_id: user.id)

    if friendship.save
      render json: {
                     success: true,
                     name: user.name
                   }
     else
      render json: { errors: "Friendship could not be created." }
     end
  end
end
