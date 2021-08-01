# frozen_string_literal: true

module Friday
  # A git repository
  class Repository < ApplicationRecord
    belongs_to :host
  end
end
