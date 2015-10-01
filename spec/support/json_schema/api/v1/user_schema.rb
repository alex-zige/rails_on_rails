module JsonSchema
  module Api
    module V1
      def self.current_user
       {
          type: :object,
          required: [:id, :email, :first_name, :last_name, :authentication_token],
          properties: {
            id: JsonSchema.integer,
            email: JsonSchema.string,
            first_name: JsonSchema.string,
            last_name: JsonSchema.string,
          }
        }
      end
    end
  end
end
