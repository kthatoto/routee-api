class ApplicationController < ActionController::API
  before_action :authenticate

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
end
