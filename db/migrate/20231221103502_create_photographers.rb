class CreatePhotographers < ActiveRecord::Migration[7.0]
  def change
    create_table :photographers do |t|
      t.string :name
      t.string :flickr_id

      t.timestamps
    end
  end
end
