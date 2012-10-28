require 'active_record'

require 'brokerage_tools/parser'

require 'pry'

module BrokerageTools
  class App

    def self.init_activerecord
      ActiveRecord::Base.establish_connection(
          :adapter   => $options.db_conf.production.adapter,
          :database  => $options.db_conf.production.database,
          :encoding  => $options.db_conf.production.encoding,
          :host      => $options.db_conf.production.host,
          :password  => $options.db_conf.production.password,
          :pool      => $options.db_conf.production.pool,
          :reconnect => $options.db_conf.production.reconnect,
          :socket    => $options.db_conf.production.socket,
          :username  => $options.db_conf.production.username)
    end

    def self.update_report_file_name
      report_file_directory = $options.app_conf.production.send($options.parser_type).report_file_directory
      report_file_name      = $options.app_conf.production.send($options.parser_type).report_file_name
      file_listing          = Dir.entries(report_file_directory)

      if file_listing.empty?
        puts "No files found in: #{report_file_directory}" 
        exit 1
      end

      file_listing.each do |file|
        file.match(/#{report_file_name}/) { |the_match| $options.app_conf.production.send("#{$options.parser_type}").report_file_name = the_match[0] }
      end

      report_file = report_file_directory + FS + $options.app_conf.production.send("#{$options.parser_type}").report_file_name

      unless File.file? report_file
        puts "File does not exist: #{report_file}"
        return false
      end
      return true
    end

    def self.parse
      require "brokerage_tools/#{$options.parser_type}/#{$options.parser_type}_parser"
      parser = 'Parser'.prepend($options.parser_type.to_s.capitalize).constantize.new

      input_dir = $options.app_conf.production.send("#{$options.parser_type}").report_file_directory
      if $options.zips
        file_listing = Dir.entries(input_dir).select { |file| File.extname(file).downcase === '.zip' }
        file_listing.each do |file|
          zip_file = Zip::ZipFile.new(input_dir + FS + file)
          zip_file.each do |entry| 
            file_name = input_dir + FS + entry.name
            File.delete file_name if File.exists? file_name
            zip_file.extract(entry, file_name)
          end

          update_report_file_name 

          parser.parse input_dir + FS + $options.app_conf.production.send("#{$options.parser_type}").report_file_name, $options.trailer
          parser.save if $options.records.nil? || $options.records == true
          parser.backup nil if $options.backup.nil? || $options.backup == true
          parser.complete
        end
      else
        update_report_file_name 

        parser.parse input_dir + FS + $options.app_conf.production.send("#{$options.parser_type}").report_file_name, $options.trailer
        parser.save if $options.records.nil? || $options.records == true
        parser.backup nil if $options.backup.nil? || $options.backup == true
        parser.complete
      end
    end

    def self.run
      $options.app_conf    = Hash.to_ostructs(YAML.load_file $options.app_conf)
      if $options.app_conf.production.send("#{$options.parser_type}").nil?
        puts "Can't find an entry for #{$options.parser_type} in your application.yml"
        exit 1
      end
      $options.db_conf     = Hash.to_ostructs(YAML.load_file $options.db_conf)
      $options.mailer_conf = Hash.to_ostructs(YAML.load_file $options.mailer_conf)

      init_activerecord

      parse unless $options.parser_type.nil?
      validate unless $options.validation_type.nil?
    end

    def self.validate
      case $options.validation_type
      when :trdrevtd
        if $options.commission_month.nil?
          puts "brokerage_tools: validation needs a month to validate against."
          puts "brokerage_tools: try with --with-commission-month 'December 2012'"
          exit 1
        end
        validator = TradeRevenueTradeDateValidator.new
        validator.validate_trdrevtd_against_fbnr($options.commission_month, $options.entity_id)
      else
        puts "validation: #{ $options.validation_type } is unknown"
        exit 1
      end
      puts validator.format_validation
      validator.email_validation($options.email_validation_to, $options.mailer_conf.production) unless $options.email_validation_to.nil?
    end

  end
end
