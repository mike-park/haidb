# change sort order for carmen countries in :de locale

# load carmen :de locale
Carmen.countries :locale => :de

# fiddle with internal contents. umlaut countries sort last unfortunately
a=Carmen.instance_variable_get '@countries'
if a && a['de']
  a['de'].sort!
end

Carmen.default_country = Site.default_country
