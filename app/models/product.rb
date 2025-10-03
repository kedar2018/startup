# app/models/product.rb
class Product < ApplicationRecord
  has_one_attached :attachment
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 255 }

  def self.ransackable_attributes(_ = nil)
    %w[id title description content created_at updated_at]
  end

  # 👇 allow Active Storage associations for filters/search
  def self.ransackable_associations(_ = nil)
    %w[image_attachment image_blob attachment_attachment attachment_blob]
  end

end
