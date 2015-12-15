# includes ....................................................................
require File.join(File.dirname(__FILE__), 'billing_trade_dt')
require 'csv'

class BillingtradedtParser < Parser

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

    #@header  = @lines.shift.chomp
    #date_len    = @report_conf.header_record.as_of_date.length
    #date_pos    = @report_conf.header_record.as_of_date.position
    #date_slice  = @header[(date_pos - 1)..(date_pos + (date_len - 2))]
    #@as_of_date = Billingtradedt.as_of_date_to_date date_slice

    fields = @report_conf.data_record.marshal_dump

    @lines.each.with_index do |record, index|
      record = CSV.parse(record)
      record = record[0]
      tmp_record = BillingTradeDt.new
      fields.each do |k, v|
        unless v.index.nil?
          v_slice = record[v.index]
          v_slice.strip unless v_slice.nil?
          tmp_record.send("#{k}=", v_slice)
        end
      end

      #File.basename(report_file) =~ /tf(\d{6})\.txt/
      #tmp_record.as_of_date     = '20' + $1[4..-1] + $1[0..3]
      tmp_record.trade_unique_identifier = Digest::SHA1.hexdigest tmp_record.transaction_control_number + tmp_record.trade_rep_id
      tmp_record.line_parsed_at = index

      # add_hash_string called after all other attributes are set
      #tmp_record.add_hash_string

      @records << tmp_record
    end
  end

  def save
    super do |action, record_index, record|
      formater_values = [
        record.send(:line_parsed_at),
        record.send(:trade_unique_identifier),
        record.send(:trade_date_or_customer_billing_start_date),
        action
      ]
      puts "Record #%s %s from %s %s" % formater_values
    end
  end
end
