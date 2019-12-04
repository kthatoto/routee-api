class RoutineTerm < ApplicationRecord

  has_many :routines

  enum interval_type: {
    daily: 0,
    weekly: 1,
    monthly: 2,
  }

  def self.prepare_current_terms(user_id, date)
    terms = RoutineTerm.where(
      'user_id = :user_id AND start_date <= :date AND :date <= end_date',
      user_id: user_id,
      date: date,
    )
    daily_term = terms.find { |t| t.daily? }
    weekly_term = terms.find { |t| t.weekly? }
    monthly_term = terms.find { |t| t.monthly? }

    create_forward_dates_count = 13
    create_forward_weeks_count = 2
    create_forward_months_count = 1
    today = Date.today

    if daily_term.nil? && (date - today) <= create_forward_dates_count
      daily_term = RoutineTerm.create!(
        user_id: user_id,
        interval_type: :daily,
        start_date: date,
        end_date: date,
      )
    end

    if weekly_term.nil? &&
      (date.beginning_of_week(:sunday) - today) / 7 <= create_forward_weeks_count
      weekly_term = RoutineTerm.create!(
        user_id: user_id,
        interval_type: :weekly,
        start_date: date.beginning_of_week(:sunday),
        end_date: date.end_of_week(:sunday),
      )
    end

    year_month = ->(date) { date.year * 12 + date.month }
    if monthly_term.nil? &&
      (year_month.call(date) - (year_month.call(today))) < create_forward_months_count
      monthly_term = RoutineTerm.create!(
        user_id: user_id,
        interval_type: :monthly,
        start_date: date.beginning_of_month,
        end_date: date.end_of_month,
      )
    end

    {daily: daily_term, weekly: weekly_term, monthly: monthly_term}.each do |type, term|
      next if term.nil?
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
