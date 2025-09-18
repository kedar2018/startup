# app/controllers/request_quotes_controller.rb
class RequestQuotesController < ApplicationController
  # If this is submitted from a public site or external client, null_session is simpler.
  protect_from_forgery with: :null_session

  def new
    @request_quote = RequestQuote.new
  end

  def create
    rq = RequestQuote.new(rq_params)

    respond_to do |format|
      if rq.save
        format.json { render json: { ok: true, id: rq.id }, status: :created }
        format.html { redirect_to(request.referer.presence || root_path, notice: "Thanks! We received your request.") }
      else
        format.json { render json: { ok: false, errors: rq.errors.full_messages }, status: :unprocessable_entity }
        format.html do
          @request_quote = rq
         flash.now[:alert] = contact.errors.full_messages.to_sentence

          render :new, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def rq_params
    params.require(:request_quote).permit(:name, :email, :service_name, :message)
  end
end
