class CreateTableMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :members do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :first_name_kana, null: false
      t.string :last_name_kana, null: false
      t.timestamps
    end
  end
end
