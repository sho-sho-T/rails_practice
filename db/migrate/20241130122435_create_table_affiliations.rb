class CreateTableAffiliations < ActiveRecord::Migration[7.2]
  def change
    create_table :affiliations do |t|
      t.bigint :group_id
      t.bigint :member_id
      t.timestamps
    end

    add_index :affiliations, :member_id
    add_index :affiliations, :group_id
    add_index :affiliations, [ :member_id, :group_id ], unique: true
  end
end
