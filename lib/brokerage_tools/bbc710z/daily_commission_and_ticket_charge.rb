# == Schema Information
#
# Table name: daily_commission_and_ticket_charges
#
#  id                                     :integer          not null, primary key
#  realm_id_number                        :string(5)
#  general_ledger_office                  :string(3)
#  adjustment_code                        :string(2)
#  rr_number                              :string(3)
#  branch_office_number                   :string(3)
#  account_number                         :string(5)
#  account_type                           :string(1)
#  check_digit                            :string(1)
#  settlement_date                        :string(6)
#  buy_sell_flag                          :string(1)
#  quantity                               :string(15)
#  quantity_sign                          :string(1)
#  price                                  :string(12)
#  blotter_code                           :string(2)
#  commission                             :string(17)
#  commission_sign                        :string(1)
#  reserved_field_00                      :string(2)
#  currency_indicator                     :string(1)
#  product_code                           :string(3)
#  contract_terms                         :string(16)
#  total_charge                           :string(17)
#  total_charge_sign                      :string(1)
#  correspondent_participation            :string(17)
#  correspondent_participation_sign       :string(1)
#  adp_security_number                    :string(7)
#  cusip_number                           :string(12)
#  ticker_symbol                          :string(12)
#  agency_principal_indicator             :string(1)
#  trade_date                             :string(6)
#  exchange_indicator                     :string(1)
#  security_indicator                     :string(1)
#  security_description_00                :string(30)
#  security_description_01                :string(30)
#  security_description_02                :string(30)
#  standard_commission                    :string(17)
#  contra_account_number                  :string(10)
#  executed_away_indicator                :string(1)
#  dot_execution_indicator                :string(1)
#  dot_elapsed_time                       :string(7)
#  contra_broker                          :string(5)
#  reserved_field_01                      :string(6)
#  ocd_code                               :string(5)
#  rr_split_ratio                         :string(4)
#  foreign_currency_code_numeric          :string(3)
#  foreign_currency_code_alpha            :string(3)
#  currency_conversion_rate_to_us_dollars :string(18)
#  tag_number                             :string(5)
#  currency_factor_indicator              :string(1)
#  principal_amount                       :string(17)
#  trailer_code_1                         :string(2)
#  trailer_code_2                         :string(2)
#  trailer_code_3                         :string(2)
#  fractional_quantity                    :string(5)
#  ticket_charge                          :string(17)
#  ticket_charge_sign                     :string(1)
#  unit_charge                            :string(17)
#  unit_charge_sign                       :string(1)
#  execution_charge                       :string(17)
#  execution_charge_sign                  :string(1)
#  principal_exchange_charge              :string(17)
#  principal_exchange_charge_sign         :string(1)
#  buy_sell_code                          :string(2)
#  root_symbol                            :string(6)
#  expiration_date                        :string(6)
#  put_call_indicator                     :string(1)
#  option_strike_price                    :string(8)
#  fund_number                            :string(4)
#  fund_description                       :string(15)
#  country_of_settlement                  :string(2)
#  sedol_number                           :string(7)
#  client_use                             :string(20)
#  mutual_fund_indicator                  :string(4)
#  commission_gross_credit_indicator      :string(1)
#  commission_principal_trade_indicator   :string(2)
#  reserved_field_02                      :string(70)
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  as_of_date                             :string(8)
#

class DailyCommissionAndTicketCharge < ActiveRecord::Base
  # validations ...............................................................
  validate :unique_record

  # class methods .............................................................

  def self.as_of_date_to_date str
    Date.strptime(str, '%m/%d/%y')
  end

  # public instance methods ...................................................

  def expiration_date=(expiration_date)
    write_attribute(:expiration_date, expiration_date)
  end

  def expiration_date
    '20' + read_attribute(:expiration_date)
  end

  def settlement_date=(settlement_date)
    write_attribute(:settlement_date, settlement_date)
  end

  def settlement_date
    '20' + read_attribute(:settlement_date)
  end

  def trade_date=(trade_date)
    write_attribute(:trade_date, trade_date)
  end

  def trade_date
    '20' + read_attribute(:trade_date)
  end

  def to_trade
    trade = Trade.new
    trade.account_number            = String::new self.account_number
    trade.account_type              = String::new self.account_type
    trade.blotter_code              = String::new self.blotter_code
    trade.branch                    = String::new self.branch_office_number
    trade.buy_sell_code             = String::new self.buy_sell_code
    trade.cancel_code               = (self.buy_sell_flag == '9' || self.buy_sell_flag == 'R') ? '1' : ''
    trade.clearing_firm             = String::new "jpm"
    trade.raw_commission            = String::new self.commission
    trade.raw_concession            = nil 
    #trade.raw_concession            = String::new self.trade_concession_05 # TODO: find concession
    trade.cusip                     = String::new self.cusip_number
    trade.entity_id                 = String::new self.rr_number
    trade.market_code               = nil
    #trade.market_code               = String::new self.market_code_01 # TODO: find market_code
    trade.raw_price                 = String::new self.price
    trade.raw_principal             = String::new self.principal_amount
    trade.raw_quantity              = String::new self.quantity
    trade.security_description_1    = String::new self.security_description_00.strip
    trade.security_description_2    = String::new self.security_description_01.strip
    trade.security_type             = String::new self.security_indicator
    trade.settle_date               = String::new self.settlement_date
    trade.solicitation_code         = nil
    #trade.solicitation_code         = String::new self.solicited_code_10 # TODO: find solicited_code
    trade.symbol                    = String::new self.ticker_symbol.strip
    trade.trade_date                = String::new self.trade_date
    trade.trade_reference_number    = String::new self.tag_number
    #trade.trade_reference_number    = String::new self.trade_reference_number_01
    trade.trade_definition_trade_id = nil
    #trade.trade_definition_trade_id = String::new self.trade_definition_trade_id_12
    return trade
  end

  # private instance methods ..................................................

  private

  def unique_record
    td = read_attribute(:trade_date)
    unless DailyCommissionAndTicketCharge.where(:as_of_date => read_attribute(:as_of_date), :trade_date => td, :buy_sell_flag => read_attribute(:buy_sell_flag), :tag_number => read_attribute(:tag_number)).first.nil?
      errors.add(:trade_date, "Record already exists: (#{as_of_date}) #{td}/#{tag_number} | #{buy_sell_flag}")
    end
  end
end
