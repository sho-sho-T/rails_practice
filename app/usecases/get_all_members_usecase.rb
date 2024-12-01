class GetAllMembersUsecase
  def initialize(params = {})
    @group_id = params[:group_id]
    @common_params = params[:common_params] || {} # 共通の検索条件
    @license_filter_params = params[:license_filter_params] || {} # ライセンスの検索条件
    @sort_by = params[:sort_by] || "last_name" # ソート項目
    @sort_order = params[:sort_order] || "asc" # ソート順
    setup_tables
  end

  def call
    union_query = build_union_query
    filtered_query = apply_filter(union_query)
    sorted_query = apply_sorting(filtered_query)

    sql = sorted_query.to_sql
    result = ActiveRecord::Base.connection.select_all(sql)
    result.map(&:to_h)
  end

  private

  # setup_tablesメソッドは、各モデルのArelテーブルをインスタンス変数として設定します。
  # これにより、Arelを使用してクエリを構築する際に、各テーブルに簡単にアクセスできるようになります。
  def setup_tables
    @group_table = Group.arel_table
    @member_table = Member.arel_table
    @member_application_detail_table = MemberApplicationDetail.arel_table
    @affiliation_table = Affiliation.arel_table
    @member_license_table = MemberLicense.arel_table
  end

  # 会員情報クエリを構築
  def build_member_query
    query = @member_table.project(
      # 会員情報のカラム
      @member_table[:id].as("member_id"),
      Arel.sql("NULL").as("member_application_detail_id"),
      @member_table[:first_name],
      @member_table[:last_name],
      @member_table[:first_name_kana],
      @member_table[:last_name_kana],
      @member_table[:division],
      @group_table[:id].as("group_id"),
      @group_table[:name].as("group_name"),
      # ライセンス情報は後でJOINする際に使用
      @member_license_table[:license_name],
      Arel.sql("'member' AS source_type")
    )

    # 所属団体との結合
    query = query.join(@affiliation_table, Arel::Nodes::OuterJoin)
                  .on(@member_table[:id].eq(@affiliation_table[:member_id]))
                  .join(@group_table, Arel::Nodes::OuterJoin)
                  .on(@affiliation_table[:group_id].eq(@group_table[:id]))
                  .join(@member_license_table, Arel::Nodes::OuterJoin)
                  .on(@member_table[:id].eq(@member_license_table[:member_id]))

    # group_idが指定されている場合はフィルタリング
    query = query.where(@affiliation_table[:group_id].eq(@group_id)) if @group_id.present?

    query
  end

  # 詳細情報のクエリを構築
  def build_member_application_detail_query
    query = @member_application_detail_table.project(
      Arel.sql("NULL").as("member_id"),
      @member_application_detail_table[:id].as("member_application_detail_id"),
      @member_application_detail_table[:first_name],
      @member_application_detail_table[:last_name],
      @member_application_detail_table[:first_name_kana],
      @member_application_detail_table[:last_name_kana],
      @member_application_detail_table[:division],
      @member_application_detail_table[:group_id],
      @group_table[:name].as("group_name"),
      Arel.sql("NULL").as("license_name"),
      Arel.sql("'member_application_detail' AS source_type")
    )

    # 所属団体と結合
    query = query.join(@group_table, Arel::Nodes::OuterJoin)
                  .on(@member_application_detail_table[:group_id].eq(@group_table[:id]))

    # MEMO:要件によってフィルタリング
    # ex　 未承認の申請のみを対象
    query = query.where(@member_application_detail_table[:member_id].eq(nil))

    # group_idが指定されている場合はフィルタリング
    query = query.where(@member_application_detail_table[:group_id].eq(@group_id)) if @group_id.present?

    query
  end

  def build_union_query
    member_query = build_member_query
    member_application_detail_query = build_member_application_detail_query
    union_query = member_query.union(member_application_detail_query)

    # 新しいテーブルを作成　
    @union_table = Arel::Table.new(:union_table)

    # SELECT文を構築し、UNIONされたクエリを元にあた新しいテーブルを作成
    Arel::SelectManager.new(@union_table)
      .project(Arel.star) # 全てのカラムを取得
      .from(Arel.sql("(#{union_query.to_sql}) AS union_table")) # UNIONされたクエリをサブクエリとして指定
  end

   # 共通フィルターとライセンスフィルターを手を適用
   def apply_filter(query)
     conditions = []

     # 共通フィルター
     if @common_filter_params.present?
       conditions += build_common_filter_conditions
     end

     # ライセンスフィルター
     if @license_filter_params.present?
       conditions += build_license_filter_conditions
     end

     conditions.reduce(query) { |q, condition| q.where(condition) }
   end

   def build_common_filter_conditions
      conditions = []

      # 区分での検索
      if @common_filter_params[:division].present?
        conditions << @union_table[:division].eq(@common_filter_params[:division])
      end

      # 姓での検索
      if @common_filter_params[:last_name].present?
        conditions << @union_table[:last_name].matches("%#{@common_filter_params[:last_name]}%")
      end

      # 名での検索
      if @common_filter_params[:first_name].present?
        conditions << @union_table[:first_name].matches("%#{@common_filter_params[:first_name]}%")
      end

      # 姓（カナ）での検索
      if @common_filter_params[:last_name_kana].present?
        conditions << @union_table[:last_name_kana].matches("%#{@common_filter_params[:last_name_kana]}%")
      end

      # 名（カナ）での検索
      if @common_filter_params[:first_name_kana].present?
        conditions << @union_table[:first_name_kana].matches("%#{@common_filter_params[:first_name_kana]}%")
      end

      conditions
   end

   def build_license_filter_conditions
     conditions = []

     # ライセンス名での検索
     if @license_filter_params[:license_name].present?
       conditions << @union_table[:license_name].matches("%#{@license_filter_params[:license_name]}%")
     end

     conditions
   end

   def apply_sorting(query)
     case @sort_by
     when "name"
        query.order(@union_table[:last_name_kana].send(@sort_order))
             .order(@union_table[:first_name_kana].send(@sort_order))
     when "division"
        query.order(@union_table[:division].send(@sort_order))
     else
        query.order(@union_table[:last_name_kana].asc)
     end
   end
end
