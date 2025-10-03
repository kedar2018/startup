# app/models/resource.rb
class Resource < ApplicationRecord
  has_one_attached :file
  validates :title, presence: true
  def self.ransackable_attributes(_=nil) = %w[id title description publish created_at updated_at]
  def self.ransackable_associations(_=nil) = %w[file_attachment file_blob]
end
