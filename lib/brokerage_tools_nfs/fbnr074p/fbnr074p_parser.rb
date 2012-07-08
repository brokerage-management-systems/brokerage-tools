require 'brokerage_tools_nfs/fbnr074p/fbnr074p_report'
require 'time'
require 'zip/zip'

require 'pry'
 
class Fbnr074pParser

  attr_accessor :fbnr074p_records 

  def initialize 
    @fbnr074p_records = []
  end

  def backup_the_report app_config
    backup_base_name = app_config['production']['fbnr074p']['backup_base_name']
    backup_directory_main = app_config['production']['fbnr074p']['backup_directory_main']
    backup_directory_alt = app_config['production']['fbnr074p']['backup_directory_alt']
    previous_date_report_directory = app_config['production']['fbnr074p']['previous_date_report_directory']
    report_file_directory = app_config['production']['fbnr074p']['report_file_directory']
    report_file_name = app_config['production']['fbnr074p']['report_file_name']

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

  def build_records_from_file lines
    can_parse = false
    payroll_month = ''
    lines.each do |line|
      break if line.include? 'SUPER EAS TOTALS'
      if payroll_month.empty?
        begin
          line.match(/.*BROKER SUMMARY REPORT.*[0-1][0-9]\/[0-3][0-9]\/[0-9]{4}.*/) { |the_match| payroll_month = format_as_mysql_date line }
        rescue ArgumentError
          require 'iconv' unless String.method_defined?(:encode)
          if String.method_defined?(:encode)
            line.encode!('UTF-8', 'UTF-8', :invalid => :replace)
          else
            ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
            line = ic.iconv(line)
          end
          line.match(/.*BROKER SUMMARY REPORT.*[0-1][0-9]\/[0-3][0-9]\/[0-9]{4}.*/) { |the_match| payroll_month = format_as_mysql_date line }
        end
      end
      if can_parse
        fbnr_record = Fbnr074pReport.new
        branch = line[2...5].strip
        fbnr_record.branch = (branch.empty?) ? 'EAM' : branch 
        broker_id = line[5...12].strip
        fbnr_record.broker_id = (broker_id.empty?) ? '000' : broker_id
        # broker name is not used
        # fbnr_record.broker_name = line[12...34].strip
        amount_of_trades = line[34...43].strip
        fbnr_record.amount_of_trades = (amount_of_trades.empty?) ? 0 : amount_of_trades
        commission = line[43...57].strip.gsub(',','')
        fbnr_record.commission = (commission.empty?) ? 0 : commission
        fbnr_record.payroll_month = payroll_month
        concession = line[57...71].strip.gsub(',','')
        fbnr_record.concession = (concession.empty?) ? 0 : concession
        concession_away = line[71...89].strip.gsub(',','')
        fbnr_record.concession_away = (concession_away.empty?) ? 0 : concession_away
        clearing = line[89...103].strip.gsub(',','')
        fbnr_record.clearing = (clearing.empty?) ? 0 : clearing
        execution = line[103...117].strip.gsub(',','')
        fbnr_record.execution = (execution.empty?) ? 0 : execution
        payout = line[117...130].strip.gsub(',','')
        fbnr_record.payout = (payout.empty?) ? 0 : payout
        fbnr_record.created_by = 0
        @fbnr074p_records << fbnr_record
        
      end
      if line.include? 'BRANCH  REP  REP NAME               TRADES   COMMISSIONS   CONCESSIONS  CONCESSIONS AWAY      CLEARING     EXECUTION       PAYOUT'
        can_parse = true
      end
    end
  end

  def format_as_mysql_date line
    mysql_date = line[line.index('BROKER SUMMARY REPORT') + 21, line.size].strip
    mysql_date = mysql_date[6...10] << '-' << mysql_date[0...2] << '-' << mysql_date[3...5]
  end

  def parse_report_file report_file
    file = File.open(report_file,'r')
    build_records_from_file file.readlines
    file.close
  end

  def save_records_to_db
    @fbnr074p_records.each do |fbnr_record|
      if fbnr_record.save
        puts "Record #{ fbrn_record } saved: #{ fbnr_record }"
      else
        puts "Error: #{ fbnr_record.errors.messages }"
        puts "\tRecord #{ fbnr_record.inspect }"
      end
    end
  end

end

