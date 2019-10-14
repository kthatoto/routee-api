class HomeController < ApplicationController

  def index
    render json: {
      daily_routines: [],
      weekly_routines: [],
      monthly_routines: [],
    }
  end
end
