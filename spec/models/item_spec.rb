require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe 'アイテムの登録' do
    context 'アイテムを登録できるとき' do
      it '必要な入力項目が存在すれば出品できる' do
        expect(@item).to be_valid
      end
    end
    context 'アイテムを登録できないとき' do
      it '画像が空では登録できない' do
        @item.images.purge 
        @item.valid?
        expect(@item.errors.full_messages).to include("画像を入力してください")
      end
      it '名前が空では登録できない' do
        @item.name = ''
        @item.valid?
        expect(@item.errors.full_messages).to include("名前を入力してください")
      end
      it 'カテゴリーが[1]では登録できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include("カテゴリーを選択してください")
      end
      it '数量が[1]では登録できない' do
        @item.quantity_id = 1
        expect(@item).to_not be_valid
        expect(@item.errors.full_messages).to include("数量を選択してください")
      end
      it 'userが紐付いてないと出品できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('Userを入力してください')
      end
    end
  end

  describe 'スコープのテスト' do
    before do
      @user = FactoryBot.build(:user)
      @item1 = FactoryBot.create(:item, name: "ItemA", category_id: 2, quantity_id: 2, color_id: 2, notes: "This is a note.")
      @item2 = FactoryBot.create(:item, name: "ItemB", category_id: 3, quantity_id: 3, color_id: 3, notes: "Another note.")
      sleep(0.1)
    end

    it '名前でフィルタリングできること' do
      expect(Item.filter_by_name("ItemA")).to include(@item1)
      expect(Item.filter_by_name("ItemA")).to_not include(@item2)
    end

    it 'カテゴリーでフィルタリングできること' do
      expect(Item.filter_by_category(2)).to include(@item1)
      expect(Item.filter_by_category(2)).to_not include(@item2)
    end

    it '数量でフィルタリングできること' do
      expect(Item.filter_by_quantity(2)).to include(@item1)
      expect(Item.filter_by_quantity(2)).to_not include(@item2)
    end

    it '色でフィルタリングできること' do
      expect(Item.filter_by_color(2)).to include(@item1)
      expect(Item.filter_by_color(2)).to_not include(@item2)
    end

    it '備考でフィルタリングできること' do
      expect(Item.filter_by_notes("note")).to include(@item1, @item2)
      expect(Item.filter_by_notes("This")).to include(@item1)
      expect(Item.filter_by_notes("This")).to_not include(@item2)
    end
  end

  describe '検索機能のテスト' do
    before do
      @user = FactoryBot.build(:user)
      @item1 = FactoryBot.create(:item, name: "SearchItemA", category_id: 2, quantity_id: 2, color_id: 2, notes: "Search note 1.")
      @item2 = FactoryBot.create(:item, name: "SearchItemB", category_id: 3, quantity_id: 3, color_id: 3, notes: "Search note 2.")
      sleep(0.1)
    end

    it '複数のフィルタ条件で検索できること' do
      params = { name: "SearchItemA", category_id: 2, quantity_id: 2 }
      results = Item.search(params)
      expect(results).to include(@item1)
      expect(results).to_not include(@item2)
    end

    it '全ての条件が存在しない場合、全てのアイテムが検索されること' do
      params = {}
      results = Item.search(params)
      expect(results).to include(@item1, @item2)
    end

    it '部分的な条件でフィルタリングできること' do
      params = { notes: "Search note" }
      results = Item.search(params)
      expect(results).to include(@item1, @item2)
    end
  end
end
