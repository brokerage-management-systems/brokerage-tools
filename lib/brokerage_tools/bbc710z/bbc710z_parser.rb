# includes ....................................................................
require File.join(File.dirname(__FILE__), 'daily_commission_and_ticket_charge')

class Bbc710zParser < Parser

  # security (i.e. attr_accessible) ...........................................
  attr_accessor :as_of_date

  # overridden from parent class ..............................................

  def initialize
    super
    @report_conf = Hash.to_ostructs(@report_conf)
  end

  def backup(report_file = nil, backup_date = nil)
    super(report_file, @as_of_date.strftime('%Y-%m-%d'))
  end

  def parse(report_file, options_trailer = nil)
    super(report_file, options_trailer)

    @header  = @lines.shift.chomp

    date_len    = @report_conf.header_record.as_of_date.length
    date_pos    = @report_conf.header_record.as_of_date.position
    date_slice  = @header[(date_pos - 1)..(date_pos + (date_len - 2))]
    @as_of_date = DailyCommissionAndTicketCharge.as_of_date_to_date date_slice

    dr_fields = @report_conf.data_record.marshal_dump

    @lines.each.with_index do |record, index|
      tmp_record = DailyCommissionAndTicketCharge.new
      dr_fields.each do |k,v|
        unless v.position.nil?
          v_slice = record[(v.position - 1)..(v.position + v.length - 2)].strip
          tmp_record.send("#{k}=", v_slice)
        end
      end
      tmp_record.as_of_date     = @as_of_date.strftime "%Y%m%d"
      tmp_record.line_parsed_at = index

      # add_hash_string called after all other attributes are set
      tmp_record.add_hash_string

      @records << tmp_record
    end
  end

  def save
    super do |action, record_index, record|
      formater_values = [
        record.send(:line_parsed_at),
        record.send(:record_hash),
        record.send(:trade_date),
        action
      ]
      puts "Record #%s %s from %s %s" % formater_values
    end
  end
end
