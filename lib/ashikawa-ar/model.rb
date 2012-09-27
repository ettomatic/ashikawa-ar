require "virtus"
require "aequitas"
require "active_support/concern"
require "active_support/core_ext/object/blank"
require "active_model/naming"
require "ashikawa-ar/search"

module Ashikawa
  module AR
    module Model
      extend ActiveSupport::Concern
      include Search

      included do
        class_eval do
          extend ActiveModel::Naming
          include Virtus
          include Aequitas
        end
      end
    end
  end
end
