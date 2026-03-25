class ItemPolicy < ApplicationPolicy
  # 詳細表示 (show)
  def show?
    authorized_user?
  end

  # 編集・更新 (edit / update)
  def update?
    authorized_user?
  end

  # 削除 (destroy)
  def destroy?
    authorized_user?
  end

  # 一覧画面 (index) での表示範囲
  class Scope < ApplicationPolicy::Scope
    def resolve
      # 「自分が作った在庫」または「共有してもらった在庫」をDBから取得
      scope.left_outer_joins(:item_shares)
           .where("items.user_id = ? OR item_shares.user_id = ?", user.id, user.id)
           .distinct
    end
  end

  private

  # 【共通の判定ロジック】
  # 1. 自分がその在庫(item)の作成者である
  # 2. または、その在庫の共有メンバー(shared_users)に自分が含まれている
  def authorized_user?
    record.user_id == user.id || record.shared_users.include?(user)
  end
end