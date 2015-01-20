require 'generators/ahoy/lib/variable_store'
require 'thor'

module Ahoy
  class QuestionHelper

    cattr_accessor :required

    def self.question(type, &block)
      question_hash = block.call
      @@required    = question_hash[:required]
      default       = question_hash[:default]
      key           = question_hash.keys[0]
      question      = "#{question_hash[key]}:"

      question_divider(default)

      case type
      when :string
        string_question(question, key, default)
      when :boolean
        boolean_question(question, key, default)
      end
    end

    def self.string_question(question, key, default=nil)
      if @@required == true
        answer = ''
        until answer != ''
          answer = Thor.new.ask(question)
          Ahoy::VariableStore.add_variable(key, answer.empty? ? default : answer)
          puts "Answer required, but you can always change it later!!!\n\n" if answer == ''
        end
      else
        answer = Thor.new.ask(question)
        Ahoy::VariableStore.add_variable(key, answer.empty? ? default : answer)
      end
    end

    def self.boolean_question(question, key, default=nil)
      answer = Thor.new.yes?(question)
      Ahoy::VariableStore.add_variable(key, answer == true ? answer : false)
    end

    def self.question_divider(value=nil)
      puts '-' * 100
      puts "Default: #{value}" unless value.nil?
    end
  end
end
