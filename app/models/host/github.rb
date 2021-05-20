# frozen_string_literal: true

class Host
  # A repository host running Github
  class Github < Host
    PROVIDER = 'github'
    DEFAULT_DOMAIN = 'github.com'

    def api_endpoint
      "https://#{domain}/api/v3" unless default_domain?
    end
  end
end
