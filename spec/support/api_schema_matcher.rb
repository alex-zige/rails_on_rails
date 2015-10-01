RSpec::Matchers.define :match_response_schema do |schema|
  match do |response|
    JSON::Validator.validate!(schema, response, strict: true)
  end
end
