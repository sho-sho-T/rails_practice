MemberApplicationDetail.seed(:id,
  {
    id: 1,
    last_name: '鈴木',
    first_name: '花子',
    last_name_kana: 'スズキ',
    first_name_kana: 'ハナコ',
    group_id: 2,
    member_id: 1,
    division: :division_1
  },
  {
    id: 2,
    last_name: '山田',
    first_name: '太郎',
    last_name_kana: 'ヤマダ',
    first_name_kana: 'タロウ',
    group_id: 1,
    member_id: 2,
    division: :division_2
  },
  {
    id: 3,
    last_name: '岡本',
    first_name: '太郎',
    last_name_kana: 'オカモト',
    first_name_kana: 'タロウ',
    group_id: 1,
    member_id: 0,
    division: :division_1
  },
  {
    id: 4,
    last_name: '佐藤',
    first_name: '次郎',
    last_name_kana: 'サトウ',
    first_name_kana: 'ジロウ',
    group_id: 1,
    member_id: 0,
    division: :division_1
  }
)
