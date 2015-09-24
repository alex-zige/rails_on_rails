# Enable if CORS is needed
# Require ENV['ALLOWED_CORS_ORIGINS']
#
#
# Rails.application.config.middleware.insert_before 0, "Rack::Cors" do
#   allow do
#     origins ENV['ALLOWED_CORS_ORIGINS']
#     resource '/api/*',
#       :headers => :any,
#       :methods => [ :head, :options, :get, :post, :put, :patch, :delete ]
#   end
# end
