class CreateTableMemberApplicationDetails < ActiveRecord::Migration[7.2]
  def change
    create_table :member_application_details do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :first_name_kana, null: false
      t.string :last_name_kana, null: false
      t.bigint :group_id
      t.bigint :member_id
      t.timestamps
    end

    add_index :member_application_details, :group_id
    add_index :member_application_details, :member_id
  end
end
