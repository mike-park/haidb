class MemberDecorator < Draper::Decorator
  delegate :full_name, :role, :notes, :team

  def status
    value = object.status
    "[#{value}]" unless value == Membership::EXPERIENCED
  end
end
