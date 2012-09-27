require "ashikawa-core"
require "ashikawa-ar/base"
require "active_support/concern"
require "ashikawa-ar/exceptions/invalid_record"

module Ashikawa
  module AR
    # Provides Persistence functionality for your model
    module Persistence
      extend ActiveSupport::Concern
      # Save the document to the database returning false if invalid
      #
      # @return [self, false] Returns false if not saved
      # @api public
      # @example Save the document to the database
      #     sam = Person.new name: "Sam Lowry"
      #     sam.save
      def save;end

      # Save the document to the database throwing an exception if invalid
      #
      # @return [self]
      # @raise [InvalidRecord] if the data is invalid
      # @api public
      # @example Save the document to the database
      #     sam = Person.new name: "Sam Lowry"
      #     sam.save!
      def save!;end

      included do
        class_eval do
          attr_reader :id

          def save
            return false unless self.valid?

            if @id.nil?
              response = self.class.collection.create self.attributes
              @id = response.id
            else
              self.class.collection[@id] = self.attributes
            end

            self
          end

          def save!
            raise InvalidRecord unless self.valid?

            if @id.nil?
              response = self.class.collection.create self.attributes
              @id = response.id
            else
              self.class.collection[@id] = self.attributes
            end

            self
          end
        end
      end
    end
  end
end
