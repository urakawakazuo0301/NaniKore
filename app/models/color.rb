class Color < ActiveHash::Base
  self.data = [
    { id: 1, name: '赤' },
    { id: 2, name: '白' },
    { id: 3, name: '黒' }
  ]

  include ActiveHash::Associations
  has_many :items
end