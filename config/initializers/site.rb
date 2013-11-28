class Site
  NAMES = %w(de uk)

  def self.name
    (ENV['SITE_NAME']||'').downcase
  end

  # fast fail
  unless NAMES.include?(name)
    raise "ENV['SITE_NAME'] must contain one of #{NAMES}"
  end
  
  class << self
    # def uk? de? etc
    NAMES.each do |n|
      define_method "#{name}?" do
        name == n
      end
    end

    def default_country
      sites = {
        'de' => 'DE',
        'uk' => 'GB'
      }
      sites[name]
    end
  end
end
