require 'refinery'

module Generators
  # The core engine installer streamlines the installation of custom generated
  # engines. It takes the migrations and seeds in your engine and moves them
  # into the rails app db directory, ready to migrate.
  class EngineInstaller < Rails::Generators::Base

    include Rails::Generators::Migration

    attr_accessor :silence_puts
    def silence_puts
      !!@silence_puts
    end

    class << self

      def engine_name(name = nil)
        @engine_name = name.to_s unless name.nil?
        @engine_name
      end

      def source_root(root = nil)
        Pathname.new(super.to_s)
      end

      # Implement the required interface for Rails::Generators::Migration.
      # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
      # can be removed once this issue is fixed:
      # # https://rails.lighthouseapp.com/projects/8994/tickets/3820-make-railsgeneratorsmigrationnext_migration_number-method-a-class-method-so-it-possible-to-use-it-in-custom-generators
      def next_migration_number(dirname)
        ::ActiveRecord::Generators::Base.next_migration_number(dirname)
      end
    end

    def generate
      Dir.glob(self.class.source_root.join('db', '**', '*.rb')).sort.each do |path|
        case path
        when %r{.*/migrate/.*}
          migration_template path, Rails.root.join('db', 'migrate', path.split('/migrate/').last.split(/^\d*_/).last)
        when %r{.*/seeds/.*}
          template path, Rails.root.join('db', 'seeds', path.split('/seeds/').last)
        end
      end

      unless self.silence_puts
        puts "------------------------"
        puts "Now run:"
        puts "rake db:migrate"
        puts "------------------------"
      end
    end
  end
end