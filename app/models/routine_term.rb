class RoutineTerm < ApplicationRecord

  has_many :routines

  enum interval_type: {
    daily: 0,
    weekly: 1,
    monthly: 2,
  }

  def self.prepare_current_terms(user_id, date)
    terms = RoutineTerm.where(
      'user_id = ? AND start_date <= ? AND ? <= end_date',
      user_id,
      date,
      date,
    )
    daily_term = terms.find { |t| t.daily? }
    weekly_term = terms.find { |t| t.weekly? }
    monthly_term = terms.find { |t| t.monthly? }
    if daily_term.nil?
      daily_term = RoutineTerm.create!(
        user_id: user_id,
        interval_type: :daily,
        start_date: date,
        end_date: date,
      )
    end
    if weekly_term.nil?
      weekly_term = RoutineTerm.create!(
        user_id: user_id,
        interval_type: :weekly,
        start_date: date.beginning_of_week(:sunday),
        end_date: date.end_of_week(:sunday),
      )
    end
    if monthly_term.nil?
      monthly_term = RoutineTerm.create!(
        user_id: user_id,
        interval_type: :monthly,
        start_date: date.beginning_of_month,
        end_date: date.end_of_month,
      )
    end

    {daily: daily_term, weekly: weekly_term, monthly: monthly_term}.each do |type, term|
      RoutineTemplate.get_by_date(user_id, type, date).each do |template|
        Routine.find_or_create_by(
          user_id: user_id,
          routine_template_id: template.id,
          routine_term_id: term.id,
        )
      end
    end

    {
      daily_term: daily_term,
      weekly_term: weekly_term,
      monthly_term: monthly_term,
    }
  end

  def serialized_routines
    routines.map { |routine| ::RoutineSerializer.new(routine) }
  end
end
