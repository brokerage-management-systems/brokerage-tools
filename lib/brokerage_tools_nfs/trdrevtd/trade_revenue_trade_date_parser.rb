require 'brokerage_tools_nfs/trdrevtd/trade_revenue_trade_date_trade'
require 'brokerage_tools_nfs/trdrevtd/trade_revenue_trade_date_trailer'

class TrdrevTdObject

  # TODO: parse date into year, month, day?

  attr_accessor :record, :field_name, :description, :position, :length, :format,
     :year, :month, :day, :start_index, :end_index

  def initialize record, field_name
    @record = record
    @field_name = field_name
    @description = TrdrevTdObject.trdrevtd_def["#{ @record }"]["#{ @field_name }"]['description']
    @position = TrdrevTdObject.trdrevtd_def["#{ @record }"]["#{ @field_name }"]['position']
    @length = TrdrevTdObject.trdrevtd_def["#{ @record }"]["#{ @field_name }"]['length']
    @format = TrdrevTdObject.trdrevtd_def["#{ @record }"]["#{ @field_name }"]['format']
  end

  def self.trdrevtd_def
    @@trdrevtd_def ||= YAML.load_file(File.dirname(__FILE__) << File::SEPARATOR << 'trdrev_td.yml')
  end

  def start_index
     @start_index ||= @position - 1
  end

  def end_index
     @end_index ||= @start_index + @length - 1
  end

end

class TradeRevenueTradeDateParser

  attr_accessor :trdrevtd_def, :trade_revenue_trade_date_trades, :trade_revenue_trade_date_trailer

  def initialize
    @trade_revenue_trade_date_trades = []
    @trade_revenue_trade_date_trailer = ''
    @trdrevtd_def = YAML.load_file(File.dirname(__FILE__) << File::SEPARATOR << 'trdrev_td.yml')
    # Test yaml for correctness
    @trdrevtd_def.each do |main_element|
      main_element[1].each do |element|
        if element[1].key? 'position'
          puts "You have a nil position: #{ element }" if element[1].fetch('position').nil?
        else
          puts element
        end

        if element[1].key? 'length'
          puts "You have a nil length: #{ element }" if element[1].fetch('length').nil?
        else
          puts element 
        end

        if element[1].key? 'mapped_to_database_field'
          puts "You have an empty mapped_to_database_field: #{ element }" if element[1].fetch('mapped_to_database_field').empty?
        else 
          puts element
        end
      end
    end
  end

  def backup_the_report app_config
    backup_base_name = app_config['production']['trdrevtd']['backup_base_name']
    backup_directory_main = app_config['production']['trdrevtd']['backup_directory_main']
    backup_directory_alt = app_config['production']['trdrevtd']['backup_directory_alt']
    previous_date_report_directory = app_config['production']['trdrevtd']['previous_date_report_directory']
    report_file_directory = app_config['production']['trdrevtd']['report_file_directory']
    report_file_name = app_config['production']['trdrevtd']['report_file_name']

    archive_file_name = backup_base_name + '_' + Time.now.strftime('%Y-%m-%d') + '.zip'
    
    if File.exists? backup_directory_main + File::SEPARATOR + archive_file_name
       FileUtils.rm backup_directory_main + File::SEPARATOR + archive_file_name
    end

    Zip::ZipFile.open(backup_directory_main + File::SEPARATOR + archive_file_name, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.add(report_file_name, report_file_directory + File::SEPARATOR + report_file_name)
    end

    unless backup_directory_alt.empty? || backup_directory_alt.nil? || backup_directory_alt.eql?(backup_directory_main)
      FileUtils.cp(backup_directory_main + File::SEPARATOR + archive_file_name, backup_directory_alt + File::SEPARATOR + archive_file_name)  
    end

    FileUtils.mv(report_file_directory + File::SEPARATOR + report_file_name, previous_date_report_directory + File::SEPARATOR + report_file_name)
  end

  def build_collection_of_trades rows_of_13
    @trade_revenue_trade_date_trades ||= []
    temp_trade = TradeRevenueTradeDateTrade.new
    row_index = 1
    rows_of_13.each do |row|
      if row_index == 1
        temp_trade = TradeRevenueTradeDateTrade.new
      end
      parse_row_at_index row.chomp, row_index, temp_trade
      if row_index == 13
        @trade_revenue_trade_date_trades << temp_trade
        row_index = 1
      else
        row_index += 1
      end
    end
  end

  # Sample data:
  # "HEAS                 FIDELITY SYSTEMS    020111    TRADE AND REVENUE                                 "
  # "T+00000011158984     000000000002381     000000000000183+0003958680+0000000000+0000090100            "
  def build_report_trailer header_row, trailer_row
    year_prefix  = Time.now.year.to_s[0..1]
    header_date  = TrdrevTdObject.new 'header', 'header_date'
    principal    = TrdrevTdObject.new 'trailer', 'total_principal'
    logical_records_ht = TrdrevTdObject.new 'trailer', 'total_logical_records_with_header_and_trailer'
    logical_records = TrdrevTdObject.new 'trailer', 'total_logical_records'
    commission      = TrdrevTdObject.new 'trailer', 'total_revenue_commission'
    concession      = TrdrevTdObject.new 'trailer', 'total_revenue_concession'
    clearing_charge = TrdrevTdObject.new 'trailer', 'total_revenue_clearing_charge'
    @trade_revenue_trade_date_trailer = TradeRevenueTradeDateTrailer.new
    @trade_revenue_trade_date_trailer.run_date  = year_prefix << header_row[45..46] << header_row[41..42] << header_row[43..44]
    @trade_revenue_trade_date_trailer.principal = trailer_row[principal.start_index..principal.end_index]
    @trade_revenue_trade_date_trailer.logical_records_ht = trailer_row[logical_records_ht.start_index..logical_records_ht.end_index]
    @trade_revenue_trade_date_trailer.logical_records = trailer_row[logical_records.start_index..logical_records.end_index]
    @trade_revenue_trade_date_trailer.commission      = trailer_row[commission.start_index..commission.end_index]
    @trade_revenue_trade_date_trailer.concession      = trailer_row[concession.start_index..concession.end_index]
    @trade_revenue_trade_date_trailer.clearing_charge = trailer_row[clearing_charge.start_index..clearing_charge.end_index]
    if @trade_revenue_trade_date_trailer.save 
      puts "Trailer saved: #{ @trade_revenue_trade_date_trailer.inspect }"
    else
      puts "Error: #{ @trade_revenue_trade_date_trailer.errors.messages }"
      puts "Trailer was not saved: #{ @trade_revenue_trade_date_trailer.inspect }"
    end
  end

  def parse_report_file(report_file, options_trailer = nil)
    file = File.open(report_file,'r')
    lines = file.readlines
    header_row = lines.shift.chomp
    trailer_row = lines.pop.chomp
    build_report_trailer header_row, trailer_row if options_trailer != false
    build_collection_of_trades lines
    file.close
  end

  def parse_row_at_index row, row_index, trade
    # puts row
    @trdrevtd_def["record_#{ (row_index < 10) ? '0' << row_index.to_s : row_index.to_s }"].each do |report_field|
      next if report_field[1]['mapped_to_database_field'].empty?
      position = report_field[1]['position'] - 1
      length = report_field[1]['length'] + position - 1
      trade[report_field[1]['mapped_to_database_field']] = row[position..length]
    end
  end

  def save_records_to_db
    record_index = 1
    @trade_revenue_trade_date_trades.each do |temp_trade|
      if temp_trade.save 
        puts "Trade ##{ record_index } saved: #{ temp_trade.run_date_01 } #{ temp_trade.trade_reference_number_01 } #{ temp_trade.user_reference_number_01 } #{ temp_trade.trade_definition_trade_id_12 } #{ temp_trade.order_reference_number_12 }"
      else
        puts "Error: #{ temp_trade.errors.messages }"
        puts "Trade ##{ record_index } was not saved: #{ temp_trade.run_date_01 } #{ temp_trade.trade_reference_number_01 } #{ temp_trade.user_reference_number_01 } #{ temp_trade.trade_definition_trade_id_12 } #{ temp_trade.order_reference_number_12 }"
      end
      record_index += 1
    end
  end

end

