class ItemSharesController < ApplicationController
  before_action :authenticate_user!

  def create
    @item = Item.find(params[:item_id])
    authorize @item, :update?

    target_user = User.find_by(email: params[:email])

    if target_user
      if target_user == current_user
        redirect_to item_path(@item), alert: "自分自身は追加できません。"
      else
        @share = @item.item_shares.find_or_initialize_by(user: target_user)
        if @share.save
          redirect_to item_path(@item), notice: "#{target_user.nickname}さんに共有しました。"
        else
          redirect_to item_path(@item), alert: "共有に失敗しました。"
        end
      end
    else
      redirect_to item_path(@item), alert: "ユーザーが見つかりませんでした。正しいメールアドレスを入力してください。"
    end
  end

  def destroy
    @item = Item.find(params[:item_id])
    authorize @item, :update?

    share = @item.item_shares.find(params[:id])
    share.destroy
    redirect_to item_path(@item), notice: "共有を解除しました。"
  end
end
