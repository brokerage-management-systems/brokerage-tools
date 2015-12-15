# == Schema Information
#
# Table name: billing_trade_dts
#
#  id                                                :integer          not null, primary key
#  firm_branch_fa                                    :string(9)
#  account_number                                    :string(8)
#  account_type                                      :string(1)
#  trade_type                                        :string(1)
#  special_account_category                          :string(3)
#  split_code                                        :string(1)
#  tto_code                                          :string(8)
#  multiple_fill_code                                :string(1)
#  trade_date_or_customer_billing_start_date         :string(8)
#  settlement_date_or_customer_fee_date              :string(8)
#  transaction_date_or_customer_billing_end_date     :string(8)
#  buy_or_sell                                       :string(1)
#  cancel_rebill_indicator                           :string(1)
#  quantity                                          :string(20)
#  security_number                                   :string(7)
#  cusip                                             :string(9)
#  symbol                                            :string(25)
#  security_description_1_or_type_of_managed_account :string(30)
#  reason_for_managed_account_fee                    :string(75)
#  managed_account_name                              :string(50)
#  price                                             :string(25)
#  principal_amount_or_amount_billed_to_customer     :string(25)
#  interest                                          :string(19)
#  filler                                            :string(255)
#  filler1                                           :string(255)
#  sec_fee                                           :string(25)
#  postage                                           :string(25)
#  handling                                          :string(19)
#  net_amount_of_trade_or_account_value              :string(25)
#  commission                                        :string(25)
#  sales_credit                                      :string(25)
#  comm_type                                         :string(255)
#  filler2                                           :string(255)
#  offset                                            :string(8)
#  dealer_number                                     :string(5)
#  product_code                                      :string(10)
#  security_type                                     :string(1)
#  security_subtype                                  :string(2)
#  product_code_description                          :string(60)
#  control_number                                    :string(25)
#  filler3                                           :string(255)
#  trade_rep_id                                      :string(5)
#  split_commission                                  :string(11)
#  full_commission_for_discounts                     :string(25)
#  split_percentage                                  :string(8)
#  discount                                          :string(25)
#  filler4                                           :string(0)
#  product_master_class                              :string(5)
#  systematic_exchange_code                          :string(1)
#  order_trade_type                                  :string(255)
#  mutual_fund_trails_amount                         :string(17)
#  managed_account_fees_amount                       :string(17)
#  postage_handling_rebate                           :string(17)
#  filler5                                           :string(255)
#  filler6                                           :string(255)
#  firm_clearance_fee_rate_set_1                     :string(17)
#  firm_execution_fee_rate_set_1                     :string(17)
#  rep_clearance_fee_rate_set_2                      :string(17)
#  rep_execution_fee_rate_set_2                      :string(17)
#  dealer_clearance                                  :string(17)
#  dealer_execution                                  :string(17)
#  cancel_as_of_fee                                  :string(17)
#  dealer_cancel_as_of_fee                           :string(17)
#  dcs_rate                                          :string(17)
#  dcs_fee                                           :string(17)
#  filler7                                           :string(255)
#  manager_rate                                      :string(25)
#  manager_fee                                       :string(17)
#  filler8                                           :string(255)
#  filler9                                           :string(255)
#  transaction_control_number                        :string(25)
#  blotter_code                                      :string(2)
#  occ_symbol                                        :string(21)
#  opra_symbol                                       :string(17)
#  thomson_one_symbol                                :string(17)
#  expanded_symbol                                   :string(20)
#  primary_exchange                                  :string(3)
#  trade_unique_identifier                           :string(40)
#  line_parsed_at                                    :integer
#  created_at                                        :datetime         not null
#  updated_at                                        :datetime         not null
#

class BillingTradeDt < ActiveRecord::Base

  EARLIEST_POSSIBLE_DATE = 20150910
  LATEST_POSSIBLE_DATE   = nil

  # validations ...............................................................
  validates :trade_unique_identifier, presence: true
  validates :trade_unique_identifier, uniqueness: true

  # class methods .............................................................
  # public instance methods ...................................................

  def to_trade
    trade = Trade.new
    trade.account_number            = String::new self.account_number
    trade.account_type              = String::new self.account_type
    trade.blotter_code              = String::new self.blotter_code || ''
    trade.branch                    = String::new self.firm_branch_fa
    trade.buy_sell_code             = String::new self.buy_or_sell
    trade.cancel_code               = (self.cancel_rebill_indicator == 'C') ? '1' : '' # 'A', 'C', 'R'
    trade.clearing_firm             = String::new "rbc"
    trade.raw_commission            = self.all_commission_sources.to_s
    trade.raw_concession            = ''
    trade.cusip                     = String::new self.cusip
    trade.entity_id                 = String::new self.trade_rep_id
    trade.market_code               = ''
    trade.raw_price                 = String::new self.price
    trade.raw_principal             = String::new self.principal_amount_or_amount_billed_to_customer
    trade.raw_quantity              = String::new self.quantity
    trade.security_description_1    = String::new self.security_description_1_or_type_of_managed_account.strip
    trade.security_description_2    = ''
    trade.security_type             = String::new self.security_type
    trade.settle_date               = String::new self.settlement_date_or_customer_fee_date
    trade.solicitation_code         = ''
    trade.symbol                    = String::new self.symbol.strip
    trade.trade_date                = String::new self.trade_date_or_customer_billing_start_date
    trade.trade_reference_number    = String::new self.transaction_control_number
    trade.trade_definition_trade_id = ''
    return trade
  end

  # private instance methods ..................................................

end

