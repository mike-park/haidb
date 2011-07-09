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

  unless self.uk? || self.de?
    raise "ENV['SITE_NAME'] must be set"
  end
  
  def self.from_email
    ENV['HAIDB_FROM_EMAIL']
  end

  def self.default_country
    sites = {
      'de' => 'DE',
      'uk' => 'GB'
    }
    sites[name]
  end

  def self.logo_big_path
    "/images/logo-big-#{name}.png"
  end

  def self.theme_color
    sites = {
      'de' => '99cc33',
      'uk' => 'd6af2e'
    }
    sites[name]
  end

  # 20% lighter
  def self.theme_color_lighter
    sites = {
      'de' => 'c2e085',
      'uk' => 'e7cf84'
    }
    sites[name]
  end
end
