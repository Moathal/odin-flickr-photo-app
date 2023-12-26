class CreatePhotographers < ActiveRecord::Migration[7.0]
  def change
    create_table :photographers do |t|
      t.string :username
      t.string :name
      t.string :nsid
      t.string :flickr_id

      t.timestamps
    end
  end
end
