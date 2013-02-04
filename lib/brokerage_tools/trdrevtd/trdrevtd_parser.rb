require File.join(File.dirname(__FILE__), 'trade_revenue_trade_date_trade')
require File.join(File.dirname(__FILE__), 'trade_revenue_trade_date_trailer')

class TrdrevtdParser < Parser

  attr_accessor :trdrevtd_trailer

  def build_collection_of_trades 
    trade = TradeRevenueTradeDateTrade.new
    row_index = 1
    # rows_of_13 = @lines
    @lines.each do |row|
      if row_index == 1
        trade = TradeRevenueTradeDateTrade.new
      end
      parse_row_at_index row.chomp, row_index, trade
      if row_index == 13
        @records << trade
        row_index = 1
      else
        row_index += 1
      end
    end
  end

  # Sample data:
  # "HEAS                 FIDELITY SYSTEMS    020111    TRADE AND REVENUE                                 "
  # "T+00000011158984     000000000002381     000000000000183+0003958680+0000000000+0000090100            "
  def build_report_trailer
    clearing_charge    = field_to_ostruct(@report_conf['trailer']['total_revenue_clearing_charge'])
    commission         = field_to_ostruct(@report_conf['trailer']['total_revenue_commission'])
    concession         = field_to_ostruct(@report_conf['trailer']['total_revenue_concession'])
    logical_records_ht = field_to_ostruct(@report_conf['trailer']['total_logical_records_with_header_and_trailer']) 
    logical_records    = field_to_ostruct(@report_conf['trailer']['total_logical_records'])
    principal          = field_to_ostruct(@report_conf['trailer']['total_principal'])
    year_prefix        = Time.now.year.to_s[0..1]

    @trdrevtd_trailer = TradeRevenueTradeDateTrailer.new
    @trdrevtd_trailer.run_date  = year_prefix << @header[45..46] << @header[41..42] << @header[43..44]
    @trdrevtd_trailer.principal = @trailer[principal.start_index..principal.end_index]
    @trdrevtd_trailer.logical_records_ht = @trailer[logical_records_ht.start_index..logical_records_ht.end_index]
    @trdrevtd_trailer.logical_records = @trailer[logical_records.start_index..logical_records.end_index]
    @trdrevtd_trailer.commission      = @trailer[commission.start_index..commission.end_index]
    @trdrevtd_trailer.concession      = @trailer[concession.start_index..concession.end_index]
    @trdrevtd_trailer.clearing_charge = @trailer[clearing_charge.start_index..clearing_charge.end_index]
    
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
 
  def initialize
    super
    @trdrevtd_trailer = ''
  end

  def backup(report_file = nil, backup_date = nil)
    super(report_file, @trdrevtd_trailer.run_date.strftime('%Y-%m-%d'))
  end

  def parse(report_file, options_trailer = nil)
    super(report_file, options_trailer)
    @header  = @lines.shift.chomp
    @trailer = @lines.pop.chomp

    build_report_trailer if options_trailer != false
    build_collection_of_trades
  end

  def save
    super { |action, record_index, record| puts "Record ##{record_index} #{action}: #{record.send(:run_date_01)} #{record.send(:trade_reference_number_01)} #{record.send(:user_reference_number_01)} #{record.send(:trade_definition_trade_id_12)} #{record.send(:order_reference_number_12)}" }
  end

end
