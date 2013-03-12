class VouchItemsController < ApplicationController
  def create
    vouch_list = VouchList.find(params[:id])
    vouch_item = vouch_list.vouch_items.build(params[:vouch_item])
    if vouch_item.save
      render json: { success: true }
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
end
