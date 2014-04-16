class Site
  def self.name
    (ENV['SITE_NAME']||'').downcase
  end
  
  def self.uk?
    self.name == 'uk'
  end

  def self.de?
    self.name == 'de'
  end

  def self.available_locales
    de? ? %w(en de) : %w(en)
  end
end
