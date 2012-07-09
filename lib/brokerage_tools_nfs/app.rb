require 'active_record'
require 'brokerage_tools_nfs/fbnr074p/fbnr074p_parser'
require 'brokerage_tools_nfs/trdrevtd/trade_revenue_trade_date_parser'
require 'brokerage_tools_nfs/trdrevtd/trade_revenue_trade_date_validator'

module BrokerageToolsNfs
  class App

    def self.init_activerecord db_config
      ActiveRecord::Base.establish_connection(
          :adapter   => db_config['production']['adapter'],
          :database  => db_config['production']['database'],
          :encoding  => db_config['production']['encoding'],
          :host      => db_config['production']['host'],
          :password  => db_config['production']['password'],
          :pool      => db_config['production']['pool'],
          :reconnect => db_config['production']['reconnect'],
          :socket    => db_config['production']['socket'],
          :username  => db_config['production']['username'])
    end

    def self.parse_file_name_from_config app_config, option_report
      report_file_directory = app_config['production']["#{ option_report }"]['report_file_directory']
      report_file_name = app_config['production']["#{ option_report }"]['report_file_name']
      file_listing = Dir.entries(report_file_directory)
      if file_listing.empty?
        puts "No files found in: #{ report_file_directory }" 
      end
      report_file = ''
      file_listing.each do |file|
        #file.match(/#{ report_file_name }/) { |the_match| report_file = report_file_directory + File::SEPARATOR + the_match[0] }
        file.match(/#{ report_file_name }/) { |the_match| app_config['production']["#{ option_report }"]['report_file_name'] = the_match[0] }
      end
      report_file = report_file_directory + File::SEPARATOR + app_config['production']["#{ option_report }"]['report_file_name']
      unless File.file? report_file
        puts "File does not exist: #{ report_file }"
        exit
      end
    end

    def self.parse options
      parse_file_name_from_config app_config, options[:report]
      report_file = app_config['production']["#{ options[:report] }"]['report_file_directory'] + File::SEPARATOR + app_config['production']["#{ options[:report] }"]['report_file_name']
      case options[:report]
      when :fbnr074p
        parser = Fbnr074pParser.new
        parser.parse_report_file report_file
      when :trdrevtd
        parser = TradeRevenueTradeDateParser.new
        parser.parse_report_file report_file, options[:trailer]
      else
        puts "report: #{ options[:report] } is unknown"
        exit 1
      end
      parser.save_records_to_db if options[:records] != false
      parser.backup_the_report app_config if options[:backup] != false
    end

    def self.run options
      app_config = YAML.load_file(options[:appconfig])
      init_activerecord YAML.load_file(options[:dbconfig])
      parse options unless options[:report].nil?
      validate options, app_config unless options[:validate].nil?
    end

    def self.validate options, app_config
      case options[:validate]
      when :trdrevtd
        if options[:commission_month].nil?
          puts "brokerage_tools_nfs: validation needs a month to validate against."
          puts "brokerage_tools_nfs: try with --with-commission-month 'December 2012'"
          exit 1
        end
        validator = TradeRevenueTradeDateValidator.new
        validator.validate_trdrevtd_against_fbnr(options[:commission_month], options[:entity_id])
      else
        puts "validation: #{ options[:validate] } is unknown"
        exit 1
      end
      puts validator.format_validation
      validator.email_validation(options[:email_validation_to], app_config['production']['mailer']) unless options[:email_validation_to].nil?
    end

  end
end

