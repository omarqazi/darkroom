class CreateGuideServers < ActiveRecord::Migration[5.1]
  def change
    create_table :guide_servers do |t|
      t.string :name
      t.string :url
      t.boolean :available_for_broadcast, default: true
      t.boolean :available_for_transcoding, default: true
      t.string :hearst_mailbox_id
      t.timestamps
    end
  end
end
