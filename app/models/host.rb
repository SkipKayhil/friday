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

  def domain_unless_default
    domain unless default_domain?
  end

  private

  def default_domain?
    domain == self.class::DEFAULT_DOMAIN
  end
end
