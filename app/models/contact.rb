class Contact < ApplicationRecord
 validates :name,    presence: true, length: { maximum: 100 }
  validates :email,   presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true, length: { maximum: 150 }
  validates :message, presence: true, length: { maximum: 2000 }

  # If your ActiveAdmin/Ransack requires allowlisting:
  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email subject message created_at updated_at]
  end
  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
