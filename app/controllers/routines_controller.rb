class RoutinesController < ApplicationController

  before_action :date_required, only: [:create]

  def create
    routine_template = RoutineTemplate.new(
      user_id: @current_user.id,
      name: params[:name],
      start_date: @date,
      description: params[:description],
      target_count: params[:count]&.to_i,
    )
  end
end
