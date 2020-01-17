module RoutineResources
  class Generator
    def initialize(param)
      @param = param
      @param.validate!
    end

    def generate_terms_and_routines
      raise "template_id is required" if @param.template.nil?
      today = Date.today
      return if today < @param.template.start_date
      end_date = [@param.template.end_date || today, today].min
      @date_range = @param.template.start_date..end_date
      case @param.template.interval_type.to_sym
      when :daily
        @terms = create_daily_terms
      when :weekly
        @terms = create_weekly_terms
      when :monthly
        @terms = create_monthly_terms
      end

      create_routines
    end

    private

      def fetch_terms
        RoutineTerm.where(
          user_id: @param.user_id,
          interval_type: @param.template.interval_type,
        ).where(
          'start_date <= :end AND :begin <= end_date',
          begin: @date_range.begin,
          end: @date_range.end,
        ).order(:start_date)
      end

      def create_daily_terms
        terms = @terms || fetch_terms
        new_terms = []
        @date_range.each do |date|
          term = terms.find {|term| term.start_date == date}
          if term.nil?
            new_terms << {
              user_id: @param.user_id, interval_type: :daily,
              start_date: date, end_date: date,
            }
          end
        end
        if new_terms.size > 0
          RoutineTerm.insert_all!(new_terms)
          return fetch_terms
        end
        terms
      end

      def create_weekly_terms
        terms = @terms || fetch_terms
        weeks = @date_range.map {|date| date.beginning_of_week(:sunday)}.uniq
        new_terms = []
        weeks.each do |date|
          term = terms.find {|term| term.start_date == date}
          if term.nil?
            new_terms << {
              user_id: @param.user_id, interval_type: :weekly,
              start_date: date, end_date: date.end_of_week(:sunday),
            }
          end
        end
        if new_terms.size > 0
          RoutineTerm.insert_all!(new_terms)
          return fetch_terms
        end
        terms
      end

      def create_monthly_terms
        terms = @terms || fetch_terms
        months = @date_range.map {|date| date.beginning_of_month}.uniq
        new_terms = []
        months.each do |date|
          term = terms.find {|term| term.start_date == date}
          if term.nil?
            new_terms << {
              user_id: @param.user_id, interval_type: :monthly,
              start_date: date, end_date: date.end_of_month,
            }
          end
        end
        if new_terms.size > 0
          RoutineTerm.insert_all!(new_terms)
          return fetch_terms
        end
        terms
      end

      def create_routines
        raise "template_id is required" if @param.template_id.nil?
        routines = @terms.map do |term|
          {
            user_id: @param.user_id,
            routine_template_id: @param.template_id,
            routine_term_id: term.id,
          }
        end
        Routine.insert_all!(routines)
      end
  end
end
