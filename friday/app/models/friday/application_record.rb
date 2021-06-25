# frozen_string_literal: true

module Friday
  # Parent class for Friday models to extend
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
