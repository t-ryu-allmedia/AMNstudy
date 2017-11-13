class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.date :date
      t.string :content
      t.string :created_by_user

      t.timestamps
    end
  end
end
