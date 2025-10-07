# app/controllers/ckeditor_uploads_controller.rb
class CkeditorUploadsController < ApplicationController
  # Replace with your auth guard (e.g., authenticate_admin_user!) if needed
  protect_from_forgery with: :exception

  def create
    file = params.require(:upload)
    blob = ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: file.original_filename,
      content_type: file.content_type
    )
    render json: { url: Rails.application.routes.url_helpers.url_for(blob) }, status: :created
  end
end
