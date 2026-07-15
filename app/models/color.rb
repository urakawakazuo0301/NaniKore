class Color < ActiveHash::Base
  self.data = [
    { id: 1, name: '赤' },
    { id: 2, name: '青' },
    { id: 3, name: 'みどり' },
    { id: 4, name: 'オレンジ' },
    { id: 5, name: 'むらさき' },
    { id: 6, name: '黒' },
    { id: 7, name: '白' },
    { id: 8, name: 'グレー' }
  ]
  include ActiveHash::Associations
  has_many :items
end
