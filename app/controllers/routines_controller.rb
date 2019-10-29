class RoutinesController < ApplicationController

  before_action :date_required, only: [:create]

  def create
    routine_template = RoutineTemplate.new(
      user_id: @current_user.id,
      interval_type: params[:interval_type],
      name: params[:name],
      start_date: @date,
      description: params[:description],
      target_count: params[:count]&.to_i,
    )
    if routine_template.save
    else
    end
  end

  def toggle_achieved
    routine = Routine.find_by(id: params[:id], user_id: @current_user.id)
    if routine.single_count?
      routine.toggle!(:achieved)
    else
      routine.increment_count!
    end
    render status: 200
  end

  def decrement
    routine = Routine.find_by(id: params[:id], user_id: @current_user.id)
    routine.decrement_count! if routine.decrementable?
    render status: 200
  end
end
