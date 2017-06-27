class GuideServer < ApplicationRecord
  has_many :channels
  validates_presence_of :url
end
