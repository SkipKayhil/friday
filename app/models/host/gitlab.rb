# frozen_string_literal: true

class Host
  # A repository host running Gitlab
  class Gitlab < Host
    PROVIDER = 'gitlab'
    DEFAULT_DOMAIN = 'gitlab.com'

    def api_endpoint
      "https://#{domain}/api/v4" unless default_domain?
    end
  end
end
