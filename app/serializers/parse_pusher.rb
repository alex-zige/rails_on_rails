# Requires "parse-ruby-client" gem
#
# class ParsePusher
#
#   def initialize(recipient, message)
#     @recipient = recipient
#     @message = message
#     @recipient_user_channel = "user_#{recipient.id}"
#   end

#   def send
#     @push = Parse::Push.new(payload, @recipient_user_channel)
#     @push.save
#   end

#   # Payload Options
#   # {
#   #   alert: 'message'
#   #   badge: '2',
#   #   sound: 'xxx.caf'
#   # }
#   def payload
#     {
#       alert: @message
#     }
#   end
#
# end