require "virtus"
require "aequitas"
require "active_support/concern"
require "ashikawa-ar/base"
require "ashikawa-ar/search"
require "ashikawa-ar/persistence"

module Ashikawa
  module AR
    module Model
      extend ActiveSupport::Concern
      include Base
      include Search
      include Persistence

      included do
        class_eval do
          include Virtus
          include Aequitas
        end
      end
    end
  end
end
