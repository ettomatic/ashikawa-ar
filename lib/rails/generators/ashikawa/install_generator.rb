require 'rails'

module Ashikawa
  module Generators
    class InstallGenerator < Rails::Generators::Base

      desc "Inject Ashikawa setup in config/application.rb"

      def inject_ashikawa

        sentinel =  /[\w]*config\.assets\.version.*/
        db_setup = 'Ashikawa::AR.setup :default, "http://127.0.0.1:8529"'

        in_root do
          inject_into_file "config/application.rb", "\n\n    #{db_setup}", { :after => sentinel, :verbose => true}
        end

      end

    end
  end
end
