class Item < ApplicationRecord

  belongs_to :user
  has_many_attached :images

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :quantity

  validates :image, presence: true
  validates :name, presence: true

  validates :category_id, numericality: { other_than: 1, message: "を選択してください" }
  validates :quantity_id, numericality: { other_than: 1, message: "を選択してください" }

end
