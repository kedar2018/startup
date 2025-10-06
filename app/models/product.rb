# app/models/product.rb
class Product < ApplicationRecord
  has_one_attached :attachment
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 255 }

 # Ransack allowlist (add other fields you filter/sort on)
  def self.ransackable_attributes(auth_object = nil)
    %w[
      id title name description content icon_style icon_name
      price status created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [] # or list associations you want searchable
  end
end
