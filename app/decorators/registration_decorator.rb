class RegistrationDecorator < Draper::Decorator
  delegate_all

  def cost
    h.local_currency(registration.cost)
  end
end
