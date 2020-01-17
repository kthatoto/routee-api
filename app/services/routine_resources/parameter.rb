module RoutineResources
  class Parameter
    include ActiveModel::Model

    attr_accessor(
      :user,     :user_id,
      :term,     :term_id,
      :template, :template_id,
      :routine,  :routine_id,
    )

    validates :user_id, presence: true

    def initialize(**params)
      super(params)
      @user        ||= User.find(@user_id) if @user_id
      @user_id     ||= @user.id if @user
      @term        ||= RoutineTerm.find(@term_id) if @term_id
      @term_id     ||= @term.id
      @template    ||= RoutineTemplate.find(@template_id) if @template_id
      @template_id ||= @template.id
      @routine     ||= Routine.find(@routine_id) if @routine_id
      @routine_id  ||= @routine.id if @routine
    end
  end
end
