class VouchItemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_list_owner_permissions,
                only: [:update, :destroy, :add_tagging, :delete_tagging]
  before_filter :check_view_permissions, only: [:get_tagging]

  def create
    vouch_list = VouchList.find(params[:id])
    vouch_item = vouch_list.vouch_items.build(params[:vouch_item])
    if vouch_item.save
      render json: {
                     success: true,
                     vouch_item_id: vouch_item.id
                   }
    else
      render json: {
                     status: 422,
                     errors: "The list was unable to be created."
                   }
    end
  end

  def destroy
    vouch_item = VouchItem.find(params[:id])
    vouch_item.destroy
    render json: { success: true }
  end

  def get_tagging
    vouch_item = VouchItem.find(params[:id])
    render json: {
                   tags: vouch_item.tags
                 }
  end

  def add_tagging
    vouch_item = VouchItem.find(params[:id])
    tag        = Tag.find_or_create_by_name(params[:name])

    # Create entry in tagging join table
    tagging    = Tagging.new(vouch_item_id: vouch_item.id,
                             tag_id: tag.id)

    if tagging.save
      render json: { success: true }
    else
      render json: {
                     status: 422,
                     errors: "The tag was unable to be saved."
                   }
    end
  end

  def delete_tagging
    vouch_item = VouchItem.find(params[:id])
    tag        = Tag.find_by_name(params[:name])
    tagging    = Tagging.find_by_vouch_item_id_and_tag_id(vouch_item.id, tag.id)
    tagging.destroy
    render json: { success: true }
  end

  private

  def check_list_owner_permissions
    vouch_item = VouchItem.find(params[:id])
    vouch_list = vouch_item.vouch_list
    unless current_user.id == vouch_list.owner.id or current_user.admin?
      redirect_to vouch_lists_path,
                  flash: {
                           error: "You do not have the permission to do this."
                         }
    end
  end

  def check_view_permissions
    # Can the current user view tags for this vouch item?
    # Yes only if the list's owner is friends with the current user.
    vouch_item = VouchItem.find(params[:id])
    vouch_list = vouch_item.vouch_list
    if (!current_user.admin?) and (vouch_list.owner.id != current_user.id)
      has_match = false
      current_user.friends.each do |friend|
        has_match = true if friend.id == vouch_list.owner.id
      end
      if has_match == false
        redirect_to root_path,
                    flash: {
                             error: "You do not have the permission to view this list."
                           }
      end
    end
  end
end
