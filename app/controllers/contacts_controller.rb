# app/controllers/contacts_controller.rb
class ContactsController < ApplicationController
  # default CSRF is ON for HTML forms

  def create
    contact = Contact.new(contact_params_html_first)
    if contact.save
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Thanks! We’ll get back to you." }
        format.json { render json: { id: contact.id, status: "ok" }, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: contact.errors.full_messages.to_sentence }
        format.json { render json: { errors: contact.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  # Works with both form_with(model: Contact.new) and raw JSON
  def contact_params_html_first
    if params[:contact].present?
      params.require(:contact).permit(:name, :email, :subject, :message)
    else
      params.permit(:name, :email, :subject, :message)
    end
  end
end
