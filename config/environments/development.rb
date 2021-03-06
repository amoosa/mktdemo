Mktdemo::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.

  # If you don't care if the mailer can't send, set this to false. Or true if you care.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    #domain:               'outfitadditions.com',
    user_name:            ENV['GMAIL_USERNAME'],
    password:             ENV['GMAIL_PWD'],
    authentication:       'plain',
    enable_starttls_auto: true  }

  config.paperclip_defaults = {
  :storage => :s3,
  :s3_credentials => {
    :bucket => ENV['S3_BUCKET_NAME'],
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  },
    :s3_protocol => :https,
    :s3_permissions => :public_read_write
}

  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false



  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

# required for devise install
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

Paperclip.options[:command_path] = 'C:\Program Files\ImageMagick-6.8.9-Q16'

          require 'paperclip/media_type_spoof_detector'
          module Paperclip
            class MediaTypeSpoofDetector
              def spoofed?
                false
              end
            end
          end

end
