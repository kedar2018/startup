class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :admin_user, optional: true

  validates :body, presence: true

  def self.ransackable_attributes(_ = nil)
    %w[id body blog_id admin_user_id created_at updated_at]
  end

  def self.ransackable_associations(_ = nil)
    %w[blog admin_user]
  end
end
