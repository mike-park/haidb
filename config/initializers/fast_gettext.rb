require "fast_gettext/translation_repository/db"

FastGettext::TranslationRepository::Db.require_models
FastGettext.add_text_domain 'app', :type => :db, :model => TranslationKey
FastGettext.default_available_locales = ['en','de', 'en-GB'] #all you want to allow
FastGettext.default_text_domain = 'app'

# allow %{foo} substitutions to contain html
GettextI18nRails.translations_are_html_safe = true
