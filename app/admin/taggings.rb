ActiveAdmin.register Tagging do
  index do
    selectable_column
    column :id, sortable: :id do |tagging|
      link_to tagging.id, admin_tagging_path(tagging)
    end
    column :vouch_item_id, sortable: :id do |tagging|
      link_to "Vouch Item #{tagging.vouch_item_id}", admin_vouch_item_path(tagging.vouch_item_id)
    end
    column :tag_id, sortable: :id do |tagging|
      link_to "Tag #{tagging.tag_id}", admin_tag_path(tagging.tag_id)
    end
    column :created_at
    column :updated_at
    default_actions
  end
end
