# app/models/product.rb
class Product < ApplicationRecord
  has_one_attached :attachment
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 255 }

  # Required for ActiveAdmin/Ransack allowlisting
  def self.ransackable_attributes(_auth_object = nil)
    %w[id title description content created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    [] # no associations to search
  end
end
