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
      client = Firebase::Auth::Client.new(ENV['FIREBASE_APIKEY'])
      token.gsub!('Bearer ', '')
      res = client.get_account_info(token)
      return nil unless res.success?
      email = res.body['users'].first['email']
      @current_user = User.find_or_create_by(email: email)
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
