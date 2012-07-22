require 'active_record'
require 'brokerage_tools_nfs/fbnr074p/fbnr074p_parser'
require 'brokerage_tools_nfs/trdrevtd/trade_revenue_trade_date_parser'
require 'brokerage_tools_nfs/trdrevtd/trade_revenue_trade_date_validator'

require 'pry'

module BrokerageToolsNfs
  class App

    attr_accessor :app_config, :db_config, :email_config, :options

    def self.init_activerecord
      ActiveRecord::Base.establish_connection(
          :adapter   => @db_config['production']['adapter'],
          :database  => @db_config['production']['database'],
          :encoding  => @db_config['production']['encoding'],
          :host      => @db_config['production']['host'],
          :password  => @db_config['production']['password'],
          :pool      => @db_config['production']['pool'],
          :reconnect => @db_config['production']['reconnect'],
          :socket    => @db_config['production']['socket'],
          :username  => @db_config['production']['username'])
    end

    def self.parse_file_name_from_config(option_report)
      report_file_directory = @app_config['production']["#{ option_report }"]['report_file_directory']
      report_file_name = @app_config['production']["#{ option_report }"]['report_file_name']
      file_listing = Dir.entries(report_file_directory)
      if file_listing.empty?
        puts "No files found in: #{ report_file_directory }" 
      end
      report_file = ''
      # mainly for the fnbr074p report which has a date appended to the file
      file_listing.each do |file|
        #file.match(/#{ report_file_name }/) { |the_match| report_file = report_file_directory + File::SEPARATOR + the_match[0] }
        file.match(/#{ report_file_name }/) { |the_match| @app_config['production']["#{ option_report }"]['report_file_name'] = the_match[0] }
      end
      report_file = report_file_directory + File::SEPARATOR + @app_config['production']["#{ option_report }"]['report_file_name']
      unless File.file? report_file
        puts "File does not exist: #{ report_file }"
        return false
      end
      return true
    end

    def self.parse(parser, report_file)
      parser.parse_report_file(report_file, @options[:trailer])
      parser.save_records_to_db if @options[:records] != false
      parser.backup_the_report @app_config if @options[:backup] != false
    end

    def self.prepare_for_parser
      case @options[:parse]
      when :fbnr074p
        parser = Fbnr074pParser.new
      when :trdrevtd
        parser = TradeRevenueTradeDateParser.new
      else
        puts "report: #{ @options[:parse] } is unknown"
        exit 1
      end
      input_dir = @app_config['production']["#{ @options[:parse] }"]['report_file_directory']
      if @options[:zips]
        file_listing = Dir.entries(input_dir).select { |file| File.extname(file).downcase === '.zip' }
        file_listing.each do |file|
          zip_file = Zip::ZipFile.new(input_dir + File::SEPARATOR + file)
          zip_file.each do |entry| 
            file_name = input_dir + File::SEPARATOR + entry.name
            File.delete file_name if File.exists? file_name
            zip_file.extract(entry, file_name)
          end
          parse_file_name_from_config(@options[:parse])
          parse(parser, input_dir + File::SEPARATOR + @app_config['production']["#{ @options[:parse] }"]['report_file_name'])
        end
      else
        parse_file_name_from_config(@options[:parse])
        parse(parser, input_dir + File::SEPARATOR + @app_config['production']["#{ @options[:parse] }"]['report_file_name'])
      end
    end

    def self.run options
      @options      = options
      @app_config   = YAML.load_file(@options[:appconfig])
      @db_config    = YAML.load_file(@options[:dbconfig])
      @email_config = YAML.load_file(@options[:emailconfig])

      init_activerecord
      prepare_for_parser unless @options[:parse].nil?
      validate unless @options[:validate].nil?
    end

    def self.validate
      case @options[:validate]
      when :trdrevtd
        if @options[:commission_month].nil?
          puts "brokerage_tools_nfs: validation needs a month to validate against."
          puts "brokerage_tools_nfs: try with --with-commission-month 'December 2012'"
          exit 1
        end
        validator = TradeRevenueTradeDateValidator.new
        validator.validate_trdrevtd_against_fbnr(@options[:commission_month], @options[:entity_id])
      else
        puts "validation: #{ @options[:validate] } is unknown"
        exit 1
      end
      puts validator.format_validation
      validator.email_validation(@options[:email_validation_to], @email_config['production']) unless @options[:email_validation_to].nil?
    end

  end
end

