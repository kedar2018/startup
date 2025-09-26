class Blog < ApplicationRecord
  belongs_to :admin_user, optional: true
  has_many   :comments, dependent: :destroy

  has_one_attached :cover_image
  attr_accessor :remove_cover_image

  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: ->(attrs) { attrs["body"].blank? }

  validates :title, presence: true
  validates :body,  presence: true

  # Ransack allowlists
  def self.ransackable_attributes(_ = nil)
    %w[id title body admin_user_id created_at updated_at]
  end

  def self.ransackable_associations(_ = nil)
    %w[admin_user comments]
  end
end
