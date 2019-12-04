class ApplicationController < ActionController::API
  before_action :authenticate
  before_action :set_date

  def authenticate
    token = request.headers["Authorization"]
    digested_token = Digest::SHA1.hexdigest(token)
    user = User.find_by(token_digest: digested_token)
    if user
      @current_user = user
    else
      render status: 401
    end
  end

  def set_date
    if params[:year] && params[:month] && params[:date]
      @date = Date.new(params[:year].to_i, params[:month].to_i, params[:date].to_i)
    end
  end

  def date_required
    render status: 422 if @date.nil?
  end
end
