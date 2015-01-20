require 'generators/ahoy/base'

module Ahoy
  module Initialize
    def root
      File.dirname(__FILE__)
    end

    def temp_dir
      File.join(File.dirname(__FILE__), 'tmp/')
    end
  end

  module Generator
    extend Initialize

    class Base < Rails::Generators::Base
      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end

      private

      def question(type, &block)
        Ahoy::QuestionHelper.question(type, &block)
      end
    end
  end
end
