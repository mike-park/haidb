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
    
    def thankyou_url
      sites = {
        'de' => {
          # language
          :de => "http://www.liebe-workshop.de/",
          :en => "http://www.liebe-workshop.de/"
        },
        'uk' => {
          # fake de language to simplify code
          :de => "http://www.hai-uk.org.uk/thx.php",
          :en => "http://www.hai-uk.org.uk/thx.php"
        }
      }
      url = sites[name][I18n.locale]
      unless url
        raise "Missing thankyou_url for #{name}:#{I18n.locale}"
      end
      url
    end
  end
end
