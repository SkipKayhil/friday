# frozen_string_literal: true

# A git repository host
class Host < ApplicationRecord
  def credentials
    {
      type: 'git_source',
      host: domain,
      username: 'x-access-token',
      password: token
    }
  end
end
