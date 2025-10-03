# config/initializers/ransack_active_storage.rb
# Allow Ransack to see ActiveStorage models without changing inheritance.

Rails.application.reloader.to_prepare do
  # ActiveStorage::Attachment
  class ActiveStorage::Attachment
    def self.ransackable_attributes(_ = nil)
      %w[id name record_type record_id blob_id created_at]
    end

    def self.ransackable_associations(_ = nil)
      %w[blob record]
    end
  end

  # ActiveStorage::Blob
  class ActiveStorage::Blob
    def self.ransackable_attributes(_ = nil)
      %w[id key filename content_type metadata service_name byte_size checksum created_at]
    end

    def self.ransackable_associations(_ = nil)
      %w[attachments variant_records]
    end
  end

  # Rails 7+ only
  if defined?(ActiveStorage::VariantRecord)
    class ActiveStorage::VariantRecord
      def self.ransackable_attributes(_ = nil)
        %w[id blob_id variation_digest created_at]
      end

      def self.ransackable_associations(_ = nil)
        %w[blob]
      end
    end
  end
end
