# == Schema Information
#
# Table name: daily_commission_and_ticket_charges
#
#  id                                     :integer(4)      not null, primary key
#  realm_id_number                        :string(5)
#  general_ledger_office                  :string(3)
#  adjustment_code                        :string(2)
#  rr_number                              :string(3)
#  account_number_00                      :string(5)
#  branch_office_number                   :string(3)
#  account_number_01                      :string(5)
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
#  created_at                             :datetime        not null
#  updated_at                             :datetime        not null
#

class DailyCommissionAndTicketCharge < ActiveRecord::Base
  # attr_accessible :title, :body
  
  validate :unique_trade
 
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

  private

  def unique_trade
    td = read_attribute(:trade_date)
    unless DailyCommissionAndTicketCharge.where(:trade_date => td, :tag_number => read_attribute(:tag_number)).first.nil?
      errors.add(:trade_date, "Trade already exists: #{td}/#{tag_number}")
    end
  end
end
