module JsonSchema
  module Api
    module V1

      def self.user
        {
          type: :object,
          required: [:id, :first_name, :last_name, :email],
          properties: {
            id: JsonSchema.integer,
            first_name: JsonSchema.string,
            last_name: JsonSchema.string,
            email: JsonSchema.string,
            profile_image_url: JsonSchema.string_or_nil
          }
        }
      end

      def self.current_user
       {
          type: :object,
          required: [:id, :email, :first_name, :last_name, :authentication_token],
          properties: {
            id: JsonSchema.integer,
            email: JsonSchema.string,
            first_name: JsonSchema.string,
            last_name: JsonSchema.string,
            authentication_token: JsonSchema.string,
            profile_image_url: JsonSchema.string_or_nil,
          }
        }
      end

     def self.simple_user
        {
          type: :object,
          required: [:id, :first_name, :last_name, :email],
          properties: {
            id: JsonSchema.integer,
            first_name: JsonSchema.string,
            last_name: JsonSchema.string,
            email: JsonSchema.string,
            profile_image_url: JsonSchema.string_or_nil
          }
        }
      end

     def self.simple_users
        {
          type: :array,
          item: simple_user
        }
      end
    end
  end
end
