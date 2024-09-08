class Item < ApplicationRecord

  belongs_to :user
  has_many_attached :images
  

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :quantity
  belongs_to :color

  validates :images, presence: true
  validates :name, presence: true

  validates :category_id, numericality: { other_than: 1, message: "を選択してください" }
  validates :quantity_id, numericality: { other_than: 1, message: "を選択してください" }


  scope :filter_by_name, -> (name) { where("name LIKE ?", "%#{name}%") }
  scope :filter_by_category, -> (category_id) { where(category_id: category_id) }
  scope :filter_by_quantity, -> (quantity_id) { where(quantity_id: quantity_id) }
  scope :filter_by_color, -> (color_id) { where(color_id: color_id) }
  scope :filter_by_notes, -> (notes) { where("notes LIKE ?", "%#{notes}%") }

  def self.search(params)
    items = Item.all
    items = items.filter_by_name(params[:name]) if params[:name].present?
    items = items.filter_by_category(params[:category_id]) if params[:category_id].present?
    items = items.filter_by_quantity(params[:quantity_id]) if params[:quantity_id].present?
    items = items.filter_by_color(params[:color_id]) if params[:color_id].present?
    items = items.filter_by_notes(params[:notes]) if params[:notes].present?
    items.order(created_at: :desc)
  end



end
