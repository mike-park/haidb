class EventObserver < ActiveRecord::Observer

  # update cached value of highest level
  def after_save(event)
    event.logger.info("#{self}: after_save #{event.display_name}")
    if event.changed.include?('level')
      event.angels.map(&:update_highest_level)
    end
  end

end
