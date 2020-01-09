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
      @date_range = @param.template.start_date..today
      case @param.template.interval_type.to_sym
      when :daily
        @terms = create_daily_terms(date_range)
        terms_map = @terms.map {|t| [t.start_date, t]}.to_h
      when :weekly
      when :monthly
      end

      create_routines(@terms)
    end

    private

      def fetch_terms(date_range)
        raise "date_range is required" if date_range.nil?
        RoutineTerm.where(
          user_id: @param.user_id,
          interval_type: @param.template.interval_type,
        ).where(
          'start_date <= :end AND :begin <= end_date',
          begin: date_range.begin,
          end: date_range.end,
        ).order(:start_date)
      end

      def create_daily_terms(date_range)
        raise "date_range is required" if date_range.nil?
        terms = @terms || fetch_terms(date_range)
        new_terms = []
        date_range.each do |date|
          term = terms.find {|term| term.start_date == date}
          if term.nil?
            new_terms << {
              user_id: @param.user_id, interval_type: :daily,
              start_date: date, end_date: date,
            }
          end
        end
        RoutineTerm.insert_all!(new_terms)
        fetch_terms
      end

      def create_routines(terms)
        raise "template_id is required" if @param.template_id.nil?
        routines = terms.map do |term|
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
