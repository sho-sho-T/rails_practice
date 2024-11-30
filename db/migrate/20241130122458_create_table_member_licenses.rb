class CreateTableMemberLicenses < ActiveRecord::Migration[7.2]
  def change
    create_table :member_licenses do |t|
      t.bigint :member_id
      t.string :license_name, null: false
      t.timestamps
    end

    add_index :member_licenses, :member_id
  end
end
