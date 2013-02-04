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

    def self.parse
      require "brokerage_tools/#{$options.parser_type}/#{$options.parser_type}_parser"
      parser = 'Parser'.prepend($options.parser_type.to_s.capitalize).constantize.new

      # iterate through files and acutally parse them (parse_file)
      directory = $options.app_conf.production.send("#{$options.parser_type}").report_file_directory
      Dir.entries(directory).each do |file|
        if $options.zips && File.extname(file.downcase) == '.zip'
          zip_file = Zip::ZipFile.new(directory + FS + file)
          zip_file.each do |entry| 
            extracted_file_name_with_path = directory + FS + entry.name
            File.delete extracted_file_name_with_path if File.exists? extracted_file_name_with_path
            zip_file.extract(entry, extracted_file_name_with_path)
            parse_file(parser, directory, entry.to_s)
            File.delete extracted_file_name_with_path if File.file?(extracted_file_name_with_path) && File.exists?(extracted_file_name_with_path)
          end
        else
          parse_file(parser, directory, file)
        end
      end
    end

    def self.parse_file(parser, directory, file)
      report_file = nil 
      file.match(/#{$options.app_conf.production.send($options.parser_type).report_file_name}/) { |the_match| report_file = the_match[0] }
      return nil unless not report_file.nil? || File.file?(report_file)

      parser.parse directory + FS + file, $options.trailer
      parser.save if $options.records.nil? || $options.records == true
      parser.backup report_file if $options.backup.nil? || $options.backup == true
      parser.complete
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
