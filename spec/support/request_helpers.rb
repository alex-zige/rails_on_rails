module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def json_ids
      json.map { |element| element['id'] } if json
    end
  end
end