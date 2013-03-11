require "ashikawa-core"
require "ashikawa-ar/base"
require "active_support/concern"
module Ashikawa
  module AR
    # Provides Search functionality for your model
    module Search
      extend ActiveSupport::Concern
      # Find a document of the collection by ID
      #
      # @param [Fixnum] id ID of the document
      # @return [Instance of Class]
      # @api public
      # @example Find a document by its ID
      #     person = Person.find my_id
      #     person.name #=> Johnny
      def self.find(id);end

      # Find a document using an AQL query
      #
      # @param [String] query The Query
      # @return [Array<Instance of Class>]
      # @api public
      # @example Find documents with an AQL query
      #     people = Person.find_by_aql "FOR u IN people RETURN u"
      #     people.first.name #=> Johnny
      def self.find_by_aql(query);end

      # Find all documents with the provided attributes
      #
      # @param [Hash] example The attributes
      # @return [Array<Instance of Class>]
      # @api public
      # @example Find a document by example
      #     people = Person.by_example name: "Johnny"
      #     people.first.name #=> Johnny
      def self.by_example(example);end

      # Find the first document with the provided attributes
      #
      # @param [Hash] example The attributes
      # @return [Instance of Class]
      # @api public
      # @example Find a document by example
      #     people = Person.first_example name: "Johnny"
      #     people.name #=> Johnny
      def self.first_example(example);end

      # Find all documents
      #
      # @return [Array<Instance of Class>]
      # @api public
      # @example Find all documents
      #     people = Person.people
      #     people.first.name #=> Johnny
      def self.all;end

      included do
        class_eval do
          def self.find(key)
            result = collection[key]
            from_raw_document result
          end

          def self.find_by_aql(query)
            results = database.query.execute query
            from_raw_documents results
          end

          def self.by_example(example)
            results = collection.query.by_example example
            from_raw_documents results
          end

          def self.first_example(example)
            result = collection.query.first_example example
            from_raw_document result.first
          end

          def self.all
            results = collection.query.all
            from_raw_documents results
          end
        end
      end
    end
  end
end
