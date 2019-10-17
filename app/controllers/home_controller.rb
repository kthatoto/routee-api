class HomeController < ApplicationController

  def index
    date = Date.new(params[:year].to_i, params[:month].to_i, params[:date].to_i)
    terms = RoutineTerm.current_terms(@current_user.id, date)
    render json: {
      daily_routines: [],
      weekly_routines: [],
      monthly_routines: [],
    }
  end
end
