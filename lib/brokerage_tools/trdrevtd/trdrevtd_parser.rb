require 'brokerage_tools/trdrevtd/trade_revenue_trade_date_trade'
require 'brokerage_tools/trdrevtd/trade_revenue_trade_date_trailer'

class TrdrevtdParser < Parser

  attr_accessor :trdrevtd_trades, :trdrevtd_trailer

  def initialize
    @parser_type = self.class.to_s.downcase[0..-7]
    yaml_conf = File.dirname(__FILE__) + FS + @parser_type + '.yml'
    if File.exists? yaml_conf
      @report_conf = YAML.load_file yaml_conf
    else
      puts "#{yaml_conf} does not exist."
      exit 1
    end
    @trdrevtd_trades = []
    @trdrevtd_trailer = ''
  end

  def build_collection_of_trades rows_of_13
    @trdrevtd_trades = []
    trade = TradeRevenueTradeDateTrade.new
    row_index = 1
    rows_of_13.each do |row|
      if row_index == 1
        trade = TradeRevenueTradeDateTrade.new
      end
      parse_row_at_index row.chomp, row_index, trade
      if row_index == 13
        @trdrevtd_trades << trade
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
    clearing_charge    = field_to_ostruct(@report_conf['trailer']['total_revenue_clearing_charge'])
    commission         = field_to_ostruct(@report_conf['trailer']['total_revenue_commission'])
    concession         = field_to_ostruct(@report_conf['trailer']['total_revenue_concession'])
    logical_records_ht = field_to_ostruct(@report_conf['trailer']['total_logical_records_with_header_and_trailer']) 
    logical_records    = field_to_ostruct(@report_conf['trailer']['total_logical_records'])
    principal          = field_to_ostruct(@report_conf['trailer']['total_principal'])
    year_prefix        = Time.now.year.to_s[0..1]

    @trdrevtd_trailer = TradeRevenueTradeDateTrailer.new
    @trdrevtd_trailer.run_date  = year_prefix << header_row[45..46] << header_row[41..42] << header_row[43..44]
    @trdrevtd_trailer.principal = trailer_row[principal.start_index..principal.end_index]
    @trdrevtd_trailer.logical_records_ht = trailer_row[logical_records_ht.start_index..logical_records_ht.end_index]
    @trdrevtd_trailer.logical_records = trailer_row[logical_records.start_index..logical_records.end_index]
    @trdrevtd_trailer.commission      = trailer_row[commission.start_index..commission.end_index]
    @trdrevtd_trailer.concession      = trailer_row[concession.start_index..concession.end_index]
    @trdrevtd_trailer.clearing_charge = trailer_row[clearing_charge.start_index..clearing_charge.end_index]
    
    return if $options.records == false

    if @trdrevtd_trailer.save 
      puts "Trailer saved: #{ @trdrevtd_trailer.inspect }"
    else
      puts "Error: #{ @trdrevtd_trailer.errors.messages }"
      puts "Trailer was not saved: #{ @trdrevtd_trailer.inspect }"
    end
  end

  def parse_row_at_index row, row_index, trade
    @report_conf["record_#{ (row_index < 10) ? '0' << row_index.to_s : row_index.to_s }"].each do |report_field|
      next if report_field[1]['mapped_to_database_field'].empty?
      position = report_field[1]['position'] - 1
      length = report_field[1]['length'] + position - 1
      trade[report_field[1]['mapped_to_database_field']] = row[position..length]
    end
  end

  def field_to_ostruct(field)
    OpenStruct.new({ :start_index => (field['position'] - 1), :end_index => (field['position'] + field['length'] - 2) })
  end

# Overridden from parent class
 
  def backup backup_date
    super(@trdrevtd_trailer.run_date.strftime '%Y-%m-%d')
  end

  def parse(report_file, options_trailer = nil)
    file        = File.open(report_file,'r')
    lines       = file.readlines

    header_row  = lines.shift.chomp
    trailer_row = lines.pop.chomp

    build_report_trailer header_row, trailer_row if options_trailer != false
    build_collection_of_trades lines

    file.close
  end

  def save
    record_index = 1
    @trdrevtd_trades.each do |trade|
      if trade.save 
        puts "Trade ##{ record_index } saved: #{ trade.run_date_01 } #{ trade.trade_reference_number_01 } #{ trade.user_reference_number_01 } #{ trade.trade_definition_trade_id_12 } #{ trade.order_reference_number_12 }"
      else
        puts "Error: #{ trade.errors.messages }"
        puts "Trade ##{ record_index } was not saved: #{ trade.run_date_01 } #{ trade.trade_reference_number_01 } #{ trade.user_reference_number_01 } #{ trade.trade_definition_trade_id_12 } #{ trade.order_reference_number_12 }"
      end
      record_index += 1
    end
  end

end
