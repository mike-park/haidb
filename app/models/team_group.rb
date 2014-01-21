class TeamGroup
  attr_reader :name, :members, :months

  def initialize(name, members, months)
    @name = name
    @members = members
    @months = months
  end

  def human_name
    @name.to_s
  end
end
