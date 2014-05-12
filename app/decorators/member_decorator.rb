class MemberDecorator < Draper::Decorator
  delegate :full_name, :role, :notes, :team, :id

  def status
    value = object.status
    "[#{value}]" unless value == Membership::EXPERIENCED
  end

  def highest_level
    object.angel.highest_level
  end
end
