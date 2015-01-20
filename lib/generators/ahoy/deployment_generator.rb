require 'rails/generators'
require 'generators/ahoy/base'
require 'generators/ahoy/lib/question_helper'
require 'generators/ahoy/lib/variable_store'
require 'fileutils'

module Ahoy
  class DeploymentGenerator < Ahoy::Generator::Base

    def prompt_user
      question :string do
        {
          app_name: 'What is the name of your application? [enter for default]',
          default: Rails.application.class.parent_name.underscore
        }
      end
      question :string do
        {
          server_domain: 'Which domain will you be deploying to? [enter for default]',
          required: true
        }
      end
      question :string do
        {
          server_user: 'Enter a name for your server user',
          required: true
        }
      end
      question :string do
        {
          server_ssh_port: 'What SSH port would you like to use on your server? [enter for default]',
          default: '22'
        }
      end
      question :string do
        {
          ruby_version: 'Which version of Ruby would you like to install? [enter for default]',
          default: '2.1.5'
        }
      end
      question :string do
        {
          postgresql_version: 'Which version of PostgreSQL would you like to install? [enter for default]',
          default: '9.3'
        }
      end
      question :string do
        {
          database_name: 'Enter a name for your production database',
          default: Rails.application.class.parent_name.underscore + '_production'
        }
      end
      question :string do
        {
          database_user: 'Enter a name for your production database user',
          required: true
        }
      end
      question :string do
        {
          database_password: 'Enter a password for your production database',
          required: true
        }
      end
      question :string do
        {
          app_repo: 'What is the github repository for this application?',
          required: true
        }
      end
      question :string do
        {
          app_repo_branch: 'Which repository branch will be used for deployment? [enter for default]',
          default: 'master'
        }
      end
    end

    def copy_directory
      directory 'ansible', 'config/ansible'
    end

    def copy_files
      copy_file '_puma.sh', 'bin/puma.sh'
      copy_file 'env_templates/_development_env.yml', '.env/development_env.yml'
      copy_file 'env_templates/_test_env.yml', '.env/test_env.yml'
    end

    def copy_templates
      template 'ansible_templates/_production', 'config/ansible/production'
      template 'ansible_templates/playbooks/_production.yml', 'config/ansible/playbooks/production.yml'
      template 'ansible_templates/playbooks/group_vars/_all.yml', 'config/ansible/playbooks/group_vars/all.yml'
      template '_puma.rb', 'config/puma.rb'
      template '_deploy.rb', 'config/deploy.rb'
      template 'env_templates/_production_env.yml', '.env/production_env.yml'
    end

    def add_gems
      gem_group :production do
        gem 'puma'
        gem 'rb-readline'
      end
    end

    def modify_files
      append_file '.gitignore', '.env/'
      inject_into_file 'config/environment.rb', after: "require File.expand_path('../application', __FILE__)\n\n" do <<-'RUBY'
Ahoy.env
      RUBY
      end
    end

    def change_permissions
      FileUtils.chmod 0751, 'config/ansible/production.sh'
      FileUtils.chmod 0751, 'bin/puma.sh'
    end

    def create_symlinks
      FileUtils.ln_s '../../../../.env/production_env.yml', 'config/ansible/playbooks/group_vars/production.yml'
    end
  end
end
