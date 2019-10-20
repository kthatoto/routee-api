class HomeController < ApplicationController

  before_action :date_required, only: [:index]

  def index
    terms = RoutineTerm.prepare_current_terms(@current_user.id, @date)
    render json: {
      daily_routines: terms[:daily_term].serialized_routines,
      weekly_routines: terms[:weekly_term].serialized_routines,
      monthly_routines: terms[:monthly_term].serialized_routines,
    }
  end
end
