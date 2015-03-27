# develop
  * [FEATURE] Add fallback config option to disable text fallback when audio prompts exist.

# v1.0.1
  * Permit any 0.x version of i18n, particularly 0.7.0

# v1.0.0
* [BUGFIX] More widely acceptable default base path (full file:// URL)

# v0.0.4
* [FEATURE] More appropriate log level output and check for empty/broken i18n locales

# v0.0.3
* [FEATURE] Add rake task to validate that all defined audio prompts are found within Adhearsion application
* [FEATURE] Allow translation lookups to fallback if an adhearsion-i18n structure isn't found

# v0.0.2
* [FEATURE] Infer audio path from language
* [FEATURE] Allow setting per-call default language
* [FEATURE] Ignore missing string translations
* [FEATURE] Make audio path configurable

# v0.0.1
* First release: Adhearsion plugin for Internationalization based on Ruby I18n
