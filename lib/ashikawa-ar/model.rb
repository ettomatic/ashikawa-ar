require "virtus"
require "aequitas"
require "active_support/concern"
require "active_support/core_ext/object/blank"
require "active_model/naming"

module Ashikawa
  module AR
    module Model
      extend ActiveSupport::Concern

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
