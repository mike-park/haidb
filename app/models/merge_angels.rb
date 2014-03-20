class MergeAngels
  EXCLUDE_FIELDS = [:id, :create_at, :updated_at, :highest_level].map(&:to_s).freeze

  attr_reader :angels

  def initialize(angels)
    @angels = angels.sort { |a, b| a.id <=> b.id }
  end

  def invoke
    Angel.transaction do
      [Registration, Membership, User].each { |model| move_many(model) }
      duplicate_angels.each { |angel| merge_angel(angel) }
      Angel.delete(duplicate_angels.map(&:id))
      first_angel.cache_highest_level
    end
    first_angel
  end

  private

  def first_angel
    angels.first
  end

  def duplicate_angels
    angels.from(1)
  end

  def merge_angel(angel)
    first_angel.update_attributes!(angel.attributes.except(*EXCLUDE_FIELDS))
  end

  def move_many(model)
    ids_field = model.to_s.downcase + "_ids"
    ids = angels.map { |a| a.send(ids_field) }.flatten
    model.send(:move_to, first_angel, ids)
  end
end