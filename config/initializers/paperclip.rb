if Rails.env.production? || Rails.env.staging?
  Paperclip::Attachment.default_options[:bucket] = ENV['AWS_S3_BUCKET']
  Paperclip::Attachment.default_options[:s3_host_name] = ENV['AWS_S3_HOST_NAME']
  Paperclip::Attachment.default_options[:s3_credentials] = {:access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']}
  Paperclip::Attachment.default_options[:s3_protocol] = "https"
  Paperclip::Attachment.default_options.merge!({ :storage => :s3, :path => ":class/:id/:attachment/:style/:filename" })

  # Use AWS CloudFront to distribute assets as CDN in production/staging and only if the host alias is specified
  if ENV['AWS_S3_HOST_ALIAS'].present?
    Paperclip::Attachment.default_options[:url] = ':s3_alias_url'
    Paperclip::Attachment.default_options[:s3_host_alias] = ENV['AWS_S3_HOST_ALIAS']
  end
end
