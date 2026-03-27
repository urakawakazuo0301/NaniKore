class ItemPolicy < ApplicationPolicy
  # アイテム登録（new / create）
  def new?
    create?
  end

  def create?
    user.present?
  end
  
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
    owner?
  end

  # 共有設定ボタン
  def share?
    owner?
  end

  # 使用済み・未使用に戻す（mark_as_used）
  def mark_as_used?
    authorized_user?
  end

  # 画像のップロード
  def upload_image?
    return true if record == Item
    authorized_user?
  end

  # 画像の削除
  def delete_image?
    authorized_user?
  end

  # 一覧画面 (index) での表示範囲
  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if user.nil?

      # 「自分が作った在庫」または「共有してもらった在庫」をDBから取得
      scope.left_outer_joins(:item_shares)
           .where("items.user_id = ? OR item_shares.user_id = ?", user.id, user.id)
           .distinct
    end
  end

  private

  # 【作成者のみ】の判定ロジック
  def owner?
    user.present? && record.user_id == user.id
  end

  # 【作成者または共有者】の判定ロジック
  def authorized_user?
    owner? || record.shared_users.include?(user)
  end
end