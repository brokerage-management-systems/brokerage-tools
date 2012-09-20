require 'brokerage_tools/payroll_month'
require 'brokerage_tools/trade'
require 'brokerage_tools/fbnr074p/fbnr074p_report'
require 'brokerage_tools/trdrevtd/trade_revenue_trade_date_trade'
require 'brokerage_tools/trdrevtd/trade_revenue_trade_date_trailer'

class TradeRevenueTradeDateValidator

  attr_accessor :broker_list, :entity_totals, :fbnr_totals, :formatted_validation, :payroll_month

  def email_validation mail_to, mailer_config 
    require 'net/smtp'
    mailer_config['message']['subject'] = "TRDREV_TD Validation Report for: #{ @payroll_month.label }" || mailer_config['message']['subject']
    mailer_config['message']['body']    = @formatted_validation || mailer_config['message']['body']

    message_content = <<END_OF_MESSAGE
From: #{mailer_config['message']['from_alias']} <#{mailer_config['message']['from']}>
To: <#{mail_to}>
Subject: #{mailer_config['message']['subject']}

#{mailer_config['message']['body']}
END_OF_MESSAGE

    Net::SMTP.start(mailer_config['smtp']['server']) do |smtp|
      smtp.send_message message_content, mailer_config['message']['from'], mail_to
    end
  end

  def format_validation 
    @formatted_validation = "*************************************************************************\n" 
    @formatted_validation << "\t TRDREV_TD Validation Report for: #{ @payroll_month.label }\n"
    @formatted_validation << "*************************************************************************\n"

    @broker_list.each do |broker|
      unless @fbnr_totals.key? broker
        @formatted_validation << "Broker: #{ broker } not found in FBNR074P Report\n" 
        next
      end
      unless @entity_totals.key? broker
        @formatted_validation << "Broker: #{ broker } not found in TRDREV_TD Report\n"
        next
      end
      fr = @fbnr_totals.fetch broker
      et = @entity_totals.fetch broker
      if fr[:commission] == et[:commission]
        @formatted_validation << "Broker: #{ broker } \tValidated \tCommission: #{ et[:commission] }\n"
      else
        @formatted_validation << "Broker: #{ broker } \tNot Validated \tDifference (from FBNR074P): #{ (et[:commission] - fr[:commission]).round(2) }\n"
        # TODO: check for cancels after month end 
      end
    end

    @formatted_validation << "*** END OF DATA ***\n"
  end

  def validate_trdrevtd_against_fbnr(commission_month_label, entity_id = nil) 
    @payroll_month = PayrollMonth.where('label = ?', commission_month_label).first
    start_date = @payroll_month.start_date.strftime("%Y%m%d")
    end_date = @payroll_month.end_date.strftime("%Y%m%d")
    @entity_totals = {}
    @fbnr_totals   = {}
    if entity_id.nil?
      @broker_list = TradeRevenueTradeDateTrade.where('settlement_date_01 BETWEEN ? AND ?', start_date, end_date).order('registered_rep_owning_rep_rr_09 ASC')
      @broker_list = @broker_list.select(:registered_rep_owning_rep_rr_09).map(&:registered_rep_owning_rep_rr_09).uniq
      @broker_list.each do |entity_id|
        @entity_totals["#{entity_id}"] = sum_brokers_commission_concession(entity_id, end_date)
      end
      fbnr_entries = Fbnr074pReport.select('broker_id, sum(amount_of_trades) as amount_of_trades, sum(commission) as commission, sum(concession) as concession').where('payroll_month = ?', end_date).order('broker_id ASC').group('broker_id')
      fbnr_entries.each { |entry| @fbnr_totals["#{ entry.broker_id }"] = { :amount_of_trades => entry.amount_of_trades, :commission => entry.commission, :concession => entry.concession } }
    else
      @entity_totals["#{entity_id}"] = sum_brokers_commission_concession(entity_id, end_date)
      fbnr_entry = Fbnr074pReport.select('broker_id, sum(amount_of_trades) as amount_of_trades, sum(commission) as commission, sum(concession) as concession').where('payroll_month = ? AND broker_id = ?', entity_id, end_date).group('broker_id').first
      @fbnr_totals["#{ fbnr_entry.broker_id }"] = { :amount_of_trades => fbnr_entry.amount_of_trades, :commission => fbnr_entry.commission, :concession => fbnr_entry.concession }
    end
    @entity_totals.each do |entity_total|
      if @fbnr_totals.key? entity_total[0]
        fbnr_total = @fbnr_totals.fetch entity_total[0]
        if fbnr_total[:commission] != entity_total[1][:commission]
          entity_total[1].merge!(:validated => false)
        else
          entity_total[1].merge!(:validated => true)
        end
      end
    end
  end

  private

  def sum_brokers_commission_concession(entity_id, commission_month)
    start_date = ""
    end_date = ""
    case commission_month.class.to_s
    when 'Hash'
      start_date = commission_month[:start_date].gsub('-', '')
      end_date = commission_month[:end_date].gsub('-', '')
    when 'String'
      payroll_month = PayrollMonth.where('end_date = ?', commission_month).first
      start_date = payroll_month.start_date.strftime("%Y%m%d")
      end_date = payroll_month.end_date.strftime("%Y%m%d")
    end
    # necessary fields are: trade_date_01, settlement_date_01
    trdrev = TradeRevenueTradeDateTrade.where('settlement_date_01 BETWEEN ? AND ? AND registered_rep_owning_rep_rr_09 = ?', start_date, end_date, entity_id)
    trades = []
    trdrev.each do |trd|
      trade = trd.to_trade
      trades << trade
    end
    Trade::bunch_array_of_trades trades
    total_commission = 0
    total_concession = 0
    trades.each do |trade|
      total_commission = total_commission + trade.raw_commission
      total_concession = total_concession + trade.raw_concession
    end
    return { :amount_of_trades => trades.size, :commission => (total_commission / 100.0).round(2), :concession => (total_concession / 100.0).round(2) }
    # return ((total_commission + total_concession) / 100.0).round(2)
  end

end

