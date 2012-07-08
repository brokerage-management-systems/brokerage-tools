require 'active_record'
require 'brokerage_tools_nfs/fbnr074p/fbnr074p_parser'
require 'brokerage_tools_nfs/trdrevtd/trade_revenue_trade_date_parser'

module BrokerageToolsNfs
  class App

    def self.init_activerecord db_config
      ActiveRecord::Base.establish_connection(
          :adapter  => db_config['production']['adapter'],
          :host     => 'localhost',
          :username => db_config['production']['username'],
          :password => db_config['production']['password'],
          :database => db_config['production']['database'])
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

    def self.run options
      app_config = YAML.load_file(options[:appconfig])
      init_activerecord YAML.load_file(options[:dbconfig])
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
        puts "report #{ options[:report] } is unknown"
        exit 1
      end
      parser.save_records_to_db if options[:records] != false
      parser.backup_the_report app_config if options[:backup] != false
    end
  end
end

