require "active_support/concern"
require "active_support/core_ext/object/blank"
require "active_model/naming"

module Ashikawa
  module AR
    module Base
      extend ActiveSupport::Concern

      included do
        class_eval do
          extend ActiveModel::Naming

          def self.collection_name
            self.model_name.collection
          end

          def self.collection
            database[collection_name]
          end

          def self.database
            Setup.databases[:default]
          end

          def self.from_raw_document(raw_document)
            self.new raw_document.to_hash
          end

          def self.from_raw_documents(raw_documents)
            raw_documents.map do |raw_document|
              from_raw_document raw_document
            end
          end
        end
      end
    end
  end
end

