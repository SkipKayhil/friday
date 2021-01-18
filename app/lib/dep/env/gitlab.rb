# frozen_string_literal: true

module Dep
  module Env
    # A wrapper around Gitlab environment variables
    module Gitlab
      module_function

      def credentials
        {
          type: 'git_source',
          host: hostname,
          username: 'x-access-token',
          password: access_token
        }
      end

      def access_token
        ENV['GITLAB_ACCESS_TOKEN'].presence || '' # raise('Missing GITLAB_ACCESS_TOKEN')
      end

      def hostname
        ENV['GITLAB_HOSTNAME'].presence || raise('Missing GITLAB_HOSTNAME')
      end
    end
  end
end
