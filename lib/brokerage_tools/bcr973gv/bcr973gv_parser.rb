require File.join(File.dirname(__FILE__), 'full_account_level_name_and_address')

class Bcr973gvParser < Parser

  attr_accessor :as_of_date

# Overridden from parent class

  def initialize
    super
    @report_conf = Hash.to_ostructs(@report_conf)
  end

  def backup(report_file = nil, backup_date = nil)
    super(report_file, @as_of_date.strftime('%Y-%m-%d'))
  end

  def parse(report_file, options_trailer = nil)
    super(report_file, options_trailer)
    @header     = @lines.shift.chomp
    @eof        = @lines.pop.chomp
    @trailer    = @lines.pop.chomp
    @as_of_date = FullAccountLevelNameAndAddress.as_of_date_to_date @header[@report_conf.header_record.as_of_date.position - 1..@report_conf.header_record.as_of_date.position + @report_conf.header_record.as_of_date.length - 2]
    dr_fields = @report_conf.detail_record.marshal_dump
    @lines.each do |record|
      tmp_record = FullAccountLevelNameAndAddress.new
      dr_fields.each { |k,v| tmp_record.send("#{k}=", record[v.position - 1..v.position + v.length - 2].strip) unless v.position.nil? }
      tmp_record.as_of_date = @as_of_date.strftime "%Y%m%d"
      @records << tmp_record
    end
  end
  
  def save
    super { |action, record_index, record| puts "Record ##{record_index} #{action}: #{record.send(:as_of_date)} #{record.send(:record_type)} #{record.send(:branch_number)} #{record.send(:account_number)}" }
  end
end
