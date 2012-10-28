require File.join(File.dirname(__FILE__), 'daily_commission_and_ticket_charge')

class Bbc710zParser < Parser

  attr_accessor :run_as_date

# Overridden from parent class

  def initialize
    super
    @report_conf = Hash.to_ostructs(@report_conf)
  end

  def backup backup_date
    super(@run_as_date.strftime '%Y-%m-%d')
  end

  def parse(report_file, options_trailer = nil)
    super(report_file, options_trailer)
    @header  = @lines.shift.chomp
    # @run_as_date = ???
    dr_fields = @report_conf.data_record.marshal_dump
    @lines.each do |record|
      tmp_record = DailyCommissionAndTicketCharge.new
      dr_fields.each { |k,v| tmp_record.send("#{k}=", record[v.position - 1..v.position + v.length - 2].strip) unless v.position.nil? }
      @records << tmp_record
    end
  end

  def save
    super { |action, record_index, record| puts "Record ##{record_index} #{action}: #{record.send(:trade_date)} #{record.send(:tag_number)} #{record.send(:trailer_code_1)} #{record.send(:trailer_code_2)} #{record.send(:trailer_code_3)}" }
  end
end
