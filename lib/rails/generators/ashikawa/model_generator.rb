module Ashikawa
  module Generators
    # Generates a Model using Ashikawa::AR for Rails
    class ModelGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      desc "Creates an Ashikawa::AR model"
      argument :attributes,
        type: :array,
        default: [],
        banner: "attribute[:type] attribute[:type]"

      check_class_collision

      def create_model_file
        template "model.rb.tt",
          File.join("app/models", class_path, "#{file_name}.rb")
      end

      hook_for :test_framework
    end
  end
end
