class HomeController < ApplicationController

  before_action :date_required, only: [:index]

  def index
    terms = RoutineTerm.prepare_current_terms(@current_user.id, @date)
    render json: {
      daily_routines: [],
      weekly_routines: [],
      monthly_routines: [],
    }
  end
end
