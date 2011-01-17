class SundayChoiceCallbacks

  def self.before_save(object)
    object.sunday_stayover = object.sunday_meal = false
    case object.sunday_choice
    when Registration::STAYOVER
      object.sunday_stayover = true
      object.sunday_meal = true
    when Registration::MEAL
      object.sunday_meal = true
    end
    true
  end

end
