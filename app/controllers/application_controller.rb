class ApplicationController < ActionController::API
  include Banken

  before_action :set_date

  def check
    render json: { user: !!current_user }
  end

  private

    def current_user
      return @current_user if @current_user
      return nil unless token = request.headers['Authorization']
      token.gsub!('Bearer ', '')
      user = User.where(token: token).where('token_valid_to >= ?', Time.current).first
      return @current_user = user if user

      client = Firebase::Auth::Client.new(ENV['FIREBASE_APIKEY'])
      res = client.get_account_info(token)
      return nil unless res.success?
      email = res.body['users'].first['email']
      user = User.find_by(email: email)
      valid_to = 1.day.since
      if user
        user.update(token: token, token_valid_to: valid_to)
      else
        user = User.create!(email: email, token: token, token_valid_to: valid_to)
      end
      @current_user = user
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
