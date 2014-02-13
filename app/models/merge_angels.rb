class MergeAngels
  def initialize(angel_ids)
    @angel_ids = angel_ids.sort
  end

  def invoke
    base = Angel.find(@angel_ids.shift)
    return false unless base
    @angel_ids.each do |angel_id|
      angel = Angel.find(angel_id)
      base.attributes = angel.attributes.except(:id, :highest_level, :created_at, :updated_at)
      # iterate as the same person (in two different angel records)
      # might be registered for the same event. this ignores registrations
      # that can't be transferred, they will be destroyed when the dup angel
      # is destroyed below
      angel.registrations.each do |r|
        base.registrations << r
      end
      base.save!
    end
    Angel.destroy(@angel_ids)
    base.cache_highest_level
    true
  end
end