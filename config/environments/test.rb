require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = false

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}",
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Test env has the same config as the global one (defined in application.rb)
  # except we separate Redis keys in each parallel test using TEST_ENV_NUMBER.
  config.cache_store = :redis_cache_store, {
    url: "redis://localhost:6379",
    namespace: "test:cache#{ENV['TEST_ENV_NUMBER']}",
  }
  config.session_store :redis_session_store,
                       key: "_lapin_session_id", # cookie name
                       redis: {
                         key_prefix: "test:session#{ENV['TEST_ENV_NUMBER']}:",
                         url: "redis://localhost:6379",
                       }

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  # config.active_storage.service = :test

  port = 9887 + ENV["TEST_ENV_NUMBER"].to_i
  config.action_mailer.default_url_options = { host: "localhost:#{port}", utm_source: "test", utm_medium: "email", utm_campaign: "default" }
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
  config.active_job.queue_adapter = :test
  Delayed::Worker.delay_jobs = false

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # https://github.com/JackC/tod/#activemodel-serializable-attribute-support
  config.active_record.time_zone_aware_types = [:datetime]

  # Actually raise a I18n::MissingTranslationData exception on missing translations.
  # This way, we can use I18n.t(...) in tests and be sure that the key exists.
  config.i18n.raise_on_missing_translations = true
  config.i18n.exception_handler = proc { |exception| raise exception.to_exception }

  # Faker fails for certains attributes if :en isn't available
  config.i18n.available_locales = %i[fr en]
  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  config.x.rack_attack.limit = 2
end
