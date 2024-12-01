module Api
  module V1
    class AllMembersController < ApplicationController
      def index
        # MEMO: 未登録を含める場合と含めない場合で取得処理を変える

        # 仮でparamsを設定
        params = {
          group_id: 1,
          common_filter_params: {
            division: 1,
            name: "山田"
          },
          license_filter_params: {
            license_name: "医師免許"
          },
          sort_by: "last_name",
          sort_order: "asc"
        }

        if include_unregistered?
          result = GetAllMembersUsecase.new(params).call
        else

        end

        respond_to do |format|
          format.json
        end
      end

      private

      def include_unregistered?
        # params[:include_unregistered] == "true"
        true
      end
    end
  end
end
