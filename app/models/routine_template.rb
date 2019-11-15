class RoutineTemplate < ApplicationRecord

  validates :name, presence: true, uniqueness: { scope: :interval_type }
  validates :start_date, presence: true
  validates :interval_type, presence: true

  enum interval_type: {
    daily: 0,
    weekly: 1,
    monthly: 2,
  }

  # @params user_id        <Integer>
  # @params interval_types <Symbol> :daily | :weekly | :monthly
  # @params date           <Date>
  def self.get_by_date(user_id, interval_type, date)
    RoutineTemplate.where(
      'archived = false AND user_id = ? AND interval_type = ? AND start_date <= ?',
      user_id,
      RoutineTemplate.interval_types[interval_type],
      date,
    )
  end

  def single_count?
    [nil, 0, 1].include?(target_count)
  end
end
