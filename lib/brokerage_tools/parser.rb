require 'time'
require 'zip/zip'

class Parser

  attr_accessor :parser_type, :report_conf, :report_file

  def initialize
    @parser_type = self.class.to_s.downcase[0..-7]
    yaml_conf = File.dirname(__FILE__) + FS + @parser_type + FS + @parser_type + '.yml'
    if File.exists? yaml_conf
      @report_conf = Hash.to_ostructs(YAML.load_file yaml_conf)
    else
      puts "#{yaml_conf} does not exist."
      exit 1
    end
  end

  def backup backup_date
    backup_base_name      = $options.app_conf.production.send("#{@parser_type}").backup_base_name
    backup_directory_main = $options.app_conf.production.send("#{@parser_type}").backup_directory_main
    backup_directory_alt  = $options.app_conf.production.send("#{@parser_type}").backup_directory_alt
    previous_date_report_directory = $options.app_conf.production.send("#{@parser_type}").previous_date_report_directory
    report_file_directory = $options.app_conf.production.send("#{@parser_type}").report_file_directory
    report_file_name      = $options.app_conf.production.send("#{@parser_type}").report_file_name

    backup_date ||= Time.now.strftime('%Y-%m-%d')
    archive_file_name = backup_base_name + '_' + backup_date + '.zip'
    
    if File.exists? backup_directory_main + FS + archive_file_name
       FileUtils.rm backup_directory_main + FS + archive_file_name
    end

    Zip::ZipFile.open(backup_directory_main + FS + archive_file_name, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.add(report_file_name, report_file_directory + FS + report_file_name)
    end

    unless backup_directory_alt.empty? || backup_directory_alt.nil? || backup_directory_alt.eql?(backup_directory_main)
      FileUtils.cp(backup_directory_main + FS + archive_file_name, backup_directory_alt + FS + archive_file_name)  
    end

    FileUtils.mv(report_file_directory + FS + report_file_name, previous_date_report_directory + FS + report_file_name)
  end

  def complete
    puts "complete"
  end

  def parse(report_file, options_trailer = nil)
    puts "parsing"
  end

  def save
    puts "saving"
  end
end
