# Be sure to restart your server when you modify this file.

# force add language. somewhere locale is added to session which is not
# what i want, hence force locale to always be visible.
# mmmenu needs to match leading /en or /de to work correctly
RoutingFilter::Locale.include_default_locale = true
