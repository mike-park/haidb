class RegistrationObserver < ActiveRecord::Observer

  # update cached value of highest level
  def after_save(registration)
    registration.logger.info("#{self}: after_save #{registration.display_name}")
    registration.angel.cache_highest_level
  end

  # update cached value of highest level
  def after_destroy(registration)
    registration.logger.info("#{self}: after_destroy #{registration.display_name}")
    registration.angel.cache_highest_level
  end

end
