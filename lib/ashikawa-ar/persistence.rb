require "ashikawa-core"
require "ashikawa-ar/base"
require "active_support/concern"
require "ashikawa-ar/exceptions/invalid_record"
require "ashikawa-ar/exceptions/unsaved_record"

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

      # Save the document to the database even if it is invalid
      #
      # @return [self] Returns false if not saved
      # @api public
      # @example Save the document to the database
      #     sam = Person.new name: "Sam Lowry"
      #     sam.save_without_validation
      def save_without_validation;end

      # Reload the record from the database
      #
      # @return [self]
      # @raise [UnsavedRecord] if the data is not yet saved
      # @api public
      # @example Get the updated version from the database
      #     sam.reload
      def reload;end

      # Delete the record from the database
      #
      # @return [self]
      # @raise [UnsavedRecord] if the data is not yet saved
      # @api public
      # @example Get the updated version from the database
      #     sam.delete
      def delete;end

      included do
        class_eval do
          attr_reader :id

          def save
            return false unless self.valid?
            save_without_validation
          end

          def save!
            raise InvalidRecord unless self.valid?
            save_without_validation
          end

          def save_without_validation
            if @id.nil?
              response = self.class.collection.create self.attributes
              @id = response.id
            else
              self.class.collection[@id] = self.attributes
            end

            self
          end

          def reload
            raise UnsavedRecord if @id.nil?
            self.attributes = self.class.collection[@id]
            self
          end

          def delete
            raise UnsavedRecord if @id.nil?
            self.class.collection[@id].delete
            self
          end
        end
      end
    end
  end
end
