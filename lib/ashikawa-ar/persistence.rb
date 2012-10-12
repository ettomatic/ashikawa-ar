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

      # Update a single attribute and write to the database
      #
      # @param [String] key Name of the attribute
      # @param [Object] value Value of the attribute
      # @return [self]
      # @raise [UnsavedRecord] if the data is not yet saved
      # @api public
      # @example Update the age
      #     sam.update_attribute "age", 39
      def update_attribute(key, value);end

      # Updates multiple attributes and write to the database
      # returning false if they are invalid
      #
      # @param [Hash] attributes
      # @return [self, false]
      # @raise [UnsavedRecord] if the data is not yet saved
      # @api public
      # @example Update the age and favorite color
      #     sam.update_attributes age: 39, favorite_color: "Green"
      def update_attributes(attributes);end

      # Updates multiple attributes and write to the database
      # throwing an exception if they are invalid
      #
      # @param [Hash] attributes
      # @return [self]
      # @raise [InvalidRecord] if the data is invalid
      # @raise [UnsavedRecord] if the data is not yet saved
      # @api public
      # @example Update the age and favorite color
      #     sam.update_attributes! age: 39, favorite_color: "Green"
      def update_attributes!(attributes);end

      # Check, if the object has been persisted
      #
      # @return [Boolean]
      # @api public
      # @example Check, if sam is persisted
      #     sam.persisted?
      def persisted?;end

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

          def check_if_saved!
            raise UnsavedRecord if @id.nil?
          end

          def reload
            check_if_saved!
            self.attributes = self.class.collection[@id]
            self
          end

          def delete
            check_if_saved!
            self.class.collection[@id].delete
            self
          end

          def update_attribute(key, value)
            check_if_saved!
            self[key] = value
            self.save
          end

          def update_attributes(attributes)
            check_if_saved!
            attributes.each_pair do |key, value|
              self[key] = value
            end

            self.save
          end

          def update_attributes!(attributes)
            check_if_saved!
            attributes.each_pair do |key, value|
              self[key] = value
            end

            self.save!
          end

          def persisted?
            !@id.nil?
          end
        end
      end
    end
  end
end
