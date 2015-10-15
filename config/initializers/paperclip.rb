Paperclip::Attachment.default_options[:bucket] = ENV['AWS_S3_BUCKET']
Paperclip::Attachment.default_options[:s3_host_name] = ENV['AWS_S3_HOST_NAME']
Paperclip::Attachment.default_options[:s3_credentials] = { access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] }
Paperclip::Attachment.default_options[:s3_protocol] = "https"

#Enable to use cloudfront to distribute assets
#Paperclip::Attachment.default_options[:s3_host_alias] = ENV['AWS_S3_HOST_ALIAS']
#Paperclip::Attachment.default_options[:url] = ':s3_alias_url'