class CreateMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :members do |t|
      t.references :organization, null: false, foreign_key: true
      t.integer :number, null: false
      t.string :first_name, null: false, limit: 50
      t.string :last_name, null: false, limit: 50
      t.string :first_name_kana, null: false, limit: 50
      t.string :last_name_kana, null: false, limit: 50
      t.date :birthday, null: false
      t.integer :sex, null: false, default: 0, limit: 1, comment: "0: 男性, 1: 女性"
      t.integer :category, null: false, default: 0, limit: 1, comment: "0: 小学生, 1: 中学生, 2: 高校生, 3: 大学生, 4: 社会人, 5: その他"
      t.text :remarks
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :members, :number
    # 組織IDと番号の組み合わせにユニーク制約を追加
    add_index :members, [ :organization_id, :number ], unique: true

    # 組織ID、姓、名の組み合わせでインデックスを追加
    add_index :members, [ :organization_id, :last_name, :first_name ]

    # 組織ID、姓カナ、名カナの組み合わせでインデックスを追加
    add_index :members, [ :organization_id, :last_name_kana, :first_name_kana ]

    # 論理削除用のインデックスを追加
    add_index :members, :deleted_at
  end
end
