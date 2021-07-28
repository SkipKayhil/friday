# frozen_string_literal: true

module Friday
  class Host
    # A repository host running Github
    class Github < Host
      PROVIDER = "github"
      DEFAULT_DOMAIN = "github.com"

      def endpoint
        "https://#{domain}/api/v3"
      end
    end
  end
end
