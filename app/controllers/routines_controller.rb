class RoutinesController < ApplicationController
  def create
    start_date = params[:start_date]&.date_string? ? Date.parse(params[:start_date]) : Date.today
    end_date = params[:end_date]&.date_string? ? Date.parse(params[:end_date]) : nil
    template = RoutineTemplate.new(
      user_id: current_user.id,
      interval_type: params[:interval_type],
      name: params[:name],
      start_date: start_date,
      end_date: end_date,
      description: params[:description],
      target_count: params[:count]&.to_i,
    )
    if template.save
      param = RoutineResources::Parameter.new(user: current_user, template: template)
      generator = RoutineResources::Generator.new(param)
      generator.generate_terms_and_routines
      render status: 200
    else
      render status: 409
    end
  end

  def status
    if (start_date_of_month = Date.new(params[:year].to_i, params[:month].to_i) rescue nil).nil?
      return render status: 400
    end
    showing_first_date = start_date_of_month.beginning_of_week(:sunday)
    showing_last_date = start_date_of_month.end_of_month.end_of_week(:sunday)
    date_range = showing_first_date..showing_last_date

    serialized_routines = Routine.includes(:routine_term).
      where(routine_terms: {start_date: date_range}).
      group_by(&:interval_type).
      transform_values do |routines|
        routines.group_by(&:start_date).values.map do |same_date_routines|
          routine = same_date_routines.first
          {
            start_date: routine.start_date,
            end_date: routine.end_date,
            total_routines_count: same_date_routines.count,
            done_routines_count: same_date_routines.select(&:achieved).count,
          }
        end
      end

    render json: serialized_routines
  end

  def toggle_achieved
    routine = Routine.find_by(id: params[:id], user_id: current_user.id)
    if routine.single_count?
      routine.toggle!(:achieved)
    else
      routine.increment_count!
    end
    render status: 200
  end

  def decrement
    routine = Routine.find_by(id: params[:id], user_id: current_user.id)
    routine.decrement_count! if routine.decrementable?
    render status: 200
  end
end
