class CreateChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :channels do |t|
      t.string :identifier # for URLs and stuff, e.g. 'live' or 'starwars'
      t.string :instruction
      t.string :title
      t.text :description
      t.boolean :broadcasting, default: false
      t.integer :guide_server_id
      t.timestamps
    end
    
    add_index :channels, :identifier
  end
end
