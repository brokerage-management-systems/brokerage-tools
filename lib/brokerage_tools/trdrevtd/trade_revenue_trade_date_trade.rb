# TODO: I didn't take the below conditional into play in the previous parser.
# Due to this the following fields are always empty:
# security_group_code, d_market_code, d_blotter_code, filler_00
#
# I should do it now though. Possibly go back and add it to all previous
# records at some point.

# At Record 7, Position 89, the layout segment Trade Revenue Transmission
# file changes based on whether the value for DUE BILL MULTIPLIER is zero
# or a logical value. If the DUE BILL MULTIPLIER is zero, then this segment
# is populated with the following alternate fields: SECURITY GROUP CODE,
# D MARKET CODE, D BLOTTER CODE and FILLER.

# == Schema Information
#
# Table name: trade_revenue_trade_date_trades
#
#  id                                      :integer(4)      not null, primary key
#  record_number_01                        :string(2)
#  firm_01                                 :string(4)
#  buy_sell_code_01                        :string(1)
#  trade_date_01                           :string(8)
#  settlement_date_01                      :string(8)
#  market_code_01                          :string(1)
#  blotter_code_01                         :string(1)
#  cancel_code_01                          :string(1)
#  street_side_code_01                     :string(1)
#  due_bill_01                             :string(1)
#  correction_code_01                      :string(1)
#  branch_01_a                             :string(3)
#  account_number_01                       :string(6)
#  account_type_01                         :string(1)
#  country_code_01                         :string(2)
#  cusip_01                                :string(9)
#  filler_01_a                             :string(5)
#  basis_price_code_01                     :string(1)
#  run_date_01                             :string(8)
#  trade_reference_number_01               :string(11)
#  user_reference_number_01                :string(11)
#  canceled_combined_reference_01          :string(11)
#  batch_01_a                              :string(4)
#  record_number_02                        :string(2)
#  batch_02_b                              :string(1)
#  count_02                                :string(6)
#  symbol_02                               :string(16)
#  security_type_02                        :string(1)
#  security_type_modifier_02               :string(1)
#  security_type_calculation_02            :string(1)
#  cns_code_02                             :string(1)
#  primary_exchange_02                     :string(2)
#  dtc_eligiblity_code_02                  :string(1)
#  foreign_code_02                         :string(1)
#  registered_rep_enter_rep_02             :string(3)
#  state_country_code_02                   :string(3)
#  ny_tax_02                               :string(1)
#  securities_instructions_02              :string(1)
#  service_02                              :string(1)
#  parent_account_02                       :string(9)
#  agency_code_02                          :string(8)
#  filler_02_b                             :string(1)
#  mode_del_02                             :string(1)
#  proceeds_instructions_02                :string(1)
#  cash_dividend_instructions_02           :string(1)
#  sales_prod_02                           :string(1)
#  trade_unit_02                           :string(1)
#  dif_principal_02                        :string(11)
#  short_name_02                           :string(10)
#  account_classification_02               :string(2)
#  citizen_code_02                         :string(1)
#  country_of_tax_residency_02             :string(3)
#  transfer_legend_code_02                 :string(1)
#  market_maker_code_02                    :string(1)
#  rr_penalty_02                           :string(1)
#  minor_executing_broker_02               :string(4)
#  minor_clearing_broker_02_a              :string(2)
#  record_number_03                        :string(2)
#  minor_clearing_broker_03_b              :string(2)
#  offset_account_03                       :string(10)
#  offset_shortname_03                     :string(10)
#  offset_rr_03                            :string(3)
#  offset_commission_03                    :string(7)
#  conf_br_override_03                     :string(3)
#  source_03                               :string(1)
#  type_of_order_03                        :string(1)
#  confirmation_print_03                   :string(1)
#  comparison_print_03                     :string(1)
#  commission_accumulation_03              :string(1)
#  commission_schedule_03                  :string(2)
#  blotter_override_code_03                :string(1)
#  nscc_code_03                            :string(1)
#  tax_accumulation_03                     :string(1)
#  commission_concession_code_03_a         :string(1)
#  substitute_blotter_03                   :string(1)
#  quantity_03                             :string(16)
#  price_03                                :string(18)
#  alphaprice_dollar_03                    :string(9)
#  alphaprice_space_03                     :string(1)
#  alphaprice_fraction_03_a                :string(8)
#  record_number_04                        :string(2)
#  alphaprice_fraction_04_b                :string(1)
#  plus_minus_04                           :string(18)
#  principal_04                            :string(15)
#  accrued_interest_04                     :string(12)
#  trade_commission_04                     :string(10)
#  state_tax_04                            :string(8)
#  sec_fee_04                              :string(8)
#  certificate_fee_04                      :string(8)
#  postage_04                              :string(8)
#  service_charge_misc_fee_04              :string(10)
#  net_04_a                                :string(1)
#  record_number_05                        :string(2)
#  net_05_b                                :string(14)
#  brokerage_05                            :string(10)
#  trade_concession_05                     :string(10)
#  other_exchange_commission_05            :string(10)
#  standard_commission_05                  :string(10)
#  limit_order_charge_05                   :string(8)
#  number_of_security_description_lines_05 :string(1)
#  security_description_line_05_a          :string(20)
#  security_description_line_05_b          :string(16)
#  record_number_06                        :string(2)
#  security_description_line_06_c          :string(4)
#  security_description_line_06_d          :string(20)
#  security_description_line_06_e          :string(20)
#  security_description_line_06_f          :string(20)
#  security_description_line_06_g          :string(20)
#  security_description_line_06_h          :string(15)
#  record_number_07                        :string(2)
#  security_description_line_07_i          :string(5)
#  security_description_line_07_j          :string(20)
#  security_description_line_07_k          :string(20)
#  group_code_07                           :string(3)
#  trader_code_07                          :string(2)
#  confirm_legend_code_07_a                :string(2)   # confirm_legend_code_01
#  confirm_legend_code_07_b                :string(2)   # confirm_legend_code_02
#  registered_rep_exec_rep_rr2_07          :string(3)
#  second_rr_percent_07                    :string(3)
#  third_rr_code_07                        :string(3)
#  third_rr_percent_07                     :string(3)
#  prospectus_enclosed_07                  :string(1)
#  commission_discount_precent_07          :string(10)
#  strike_price_07                         :string(9)
#  due_bill_multiplier_07                  :string(5)
#  postage_code_07                         :string(1)
#  commission_concession_code_07_b         :string(1)
#  commission_preference_code_07           :string(1)
#  filler_07_d                             :string(2)
#  fund_load_override_07_a                 :string(3)
#  record_number_08                        :string(2)
#  fund_load_override_08_b                 :string(1)
#  quantity_type_08                        :string(1)
#  confirm_line_number_08                  :string(1)
#  exchange_line_number_08                 :string(1)
#  yield_08                                :string(5)
#  yield_type_08                           :string(1)
#  yield_date_08                           :string(7)
#  yield_price_08                          :string(6)
#  trading_away_code_08                    :string(1)
#  filler_08_e                             :string(7)
#  major_clearing_broker_08                :string(4)
#  major_executing_broker_08               :string(4)
#  execution_time_08                       :string(4)
#  branch_08_b                             :string(3)
#  irs_no_08                               :string(9)
#  filler_08_f                             :string(3)
#  market_place_08                         :string(5)
#  market_sequence_08                      :string(6)
#  market_override_08                      :string(1)
#  time_in_force_code_08                   :string(1)
#  auto_exec_code_08                       :string(1)
#  issuer_08                               :string(6)
#  issuer_type_08                          :string(2)
#  bond_trader_08                          :string(4)
#  bond_class_code_08                      :string(1)
#  additional_markup_08                    :string(10)
#  terminal_id_08                          :string(4)
#  record_number_09                        :string(2)
#  signon_rep_location_09                  :string(5)
#  registered_rep_signon_rep_09            :string(3)
#  registered_rep_owning_rep_rr_09         :string(3)
#  fund_load_percent_09                    :string(4)
#  product_code_09                         :string(12)
#  trading_flat_code_09                    :string(1)
#  _12b1_09                                :string(1)
#  additional_fee_code_09_a                :string(2)
#  additional_fee_amount_09_a              :string(9)
#  additional_fee_code_09_b                :string(2)
#  additional_fee_amount_09_b              :string(9)
#  additional_fee_code_09_c                :string(2)
#  additional_fee_amount_09_c              :string(9)
#  additional_fee_code_09_d                :string(2)
#  additional_fee_amount_09_d              :string(9)
#  additional_fee_code_09_e                :string(2)
#  additional_fee_amount_09_e              :string(9)
#  additional_fee_code_09_f                :string(2)
#  additional_fee_amount_09_f              :string(9)
#  institutional_third_party_09            :string(4)
#  record_number_10                        :string(2)
#  institutional_misc1_10                  :string(4)
#  institutional_misc2_10                  :string(4)
#  institutional_lot_number_10             :string(4)
#  bord_tord_code_10                       :string(1)
#  mutual_fund_dtc_number_10               :string(4)
#  filler_10_g                             :string(1)
#  trade_entry_10                          :string(6)
#  entry_sequence_number_10                :string(5)
#  solicited_code_10                       :string(1)
#  electronic_trade_id_10                  :string(3)
#  rollup_count_10                         :string(3)
#  confirm_legend_code_10_a                :string(2)
#  confirm_legend_code_10_b                :string(2)
#  relationship_id_10                      :string(12)
#  capacity_code_10                        :string(1)
#  confirm_legend_code_10_c                :string(2)
#  confirm_legend_code_10_d                :string(2)
#  alternative_investment_code_10          :string(1)
#  expanded_yield_10                       :string(9)
#  expanded_yield_sign_10                  :string(1)
#  filler_10_h                             :string(31)
#  record_number_11                        :string(2)
#  filler_11_i                             :string(86)
#  revenue_clearing_charge_sign_11         :string(1)
#  revenue_clearing_charge_amount_11       :string(7)
#  revenue_miscellaneous_fee_sign_11       :string(1)
#  revenue_miscellaneous_fee_amount_11_a   :string(4)
#  record_number_12                        :string(2)
#  revenue_miscellaneous_fee_amount_12_b   :string(3)
#  product_level_12                        :string(2)
#  concession_code_12                      :string(1)
#  purchase_type_code_12                   :string(2)
#  trade_definition_type_12                :string(1)
#  trade_definition_trade_id_12            :string(9)
#  revenue_commission_sign_12              :string(1)
#  revenue_commission_amount_12            :string(7)
#  revenue_concession_sign_12              :string(1)
#  revenue_concession_amount_12            :string(7)
#  revenue_load_sign_12                    :string(1)
#  revenue_load_amount_12                  :string(7)
#  order_reference_number_12               :string(11)
#  filler_12_j                             :string(9)
#  input_commission_sign_12                :string(1)
#  input_commission_amount_12              :string(10)
#  confirm_legend_code_12_a                :string(2)   # confirm_legend_code_00
#  confirm_legend_code_12_b                :string(2)   # confirm_legend_code_01
#  filler_12_k                             :string(2)
#  original_description_12_a               :string(20)
#  record_number_13                        :string(2)
#  original_description_13_b               :string(20)
#  execution_time_13                       :string(6)
#  registered_rep_pay_to_rep_13            :string(3)
#  clearing_charge_sign_13                 :string(1)
#  clearing_charge_13                      :string(7)
#  execution_fee_sign_13                   :string(1)
#  execution_fee_13                        :string(7)
#  foreign_surcharge_sign_13               :string(1)
#  foreign_surcharge_13                    :string(6)
#  filler_13_l                             :string(7)
#  super_branch_13                         :string(3)
#  filler_13_m                             :string(37)
#

class TradeRevenueTradeDateTrade < ActiveRecord::Base

  EARLIEST_POSSIBLE_DATE = 20090122
  LATEST_POSSIBLE_DATE   = 20120924 # Actual last date for data 20121025

  # relationships .............................................................
  belongs_to :trade_revenue_trade_date_trailer

  # validations ...............................................................
  validates_uniqueness_of :run_date_01, :scope => [:trade_reference_number_01, :user_reference_number_01, :trade_definition_trade_id_12, :order_reference_number_12]

  # class methods .............................................................

  def self.parse_quantity_field trade
    temp_quantity = (trade.quantity_03.class == Fixnum) ? trade.quantity_03 : trade.quantity_03.to_s.insert(-6, ".").to_i
    if trade.cancel_code_01 === '1'
        temp_quantity = -temp_quantity
    end
    return temp_quantity
  end

  # public instance methods ...................................................

  def to_trade
    trade = Trade.new
    trade.account_number            = String::new self.account_number_01
    trade.account_type              = String::new self.account_type_01
    trade.blotter_code              = String::new self.blotter_code_01
    trade.branch                    = String::new self.branch_01_a
    trade.buy_sell_code             = String::new self.buy_sell_code_01
    trade.cancel_code               = String::new self.cancel_code_01
    trade.raw_commission            = String::new self.trade_commission_04
    trade.raw_concession            = String::new self.trade_concession_05
    trade.cusip                     = String::new self.cusip_01
    trade.entity_id                 = String::new self.registered_rep_owning_rep_rr_09
    trade.market_code               = String::new self.market_code_01
    trade.raw_price                 = String::new self.alphaprice_dollar_03 + self.alphaprice_space_03 + self.alphaprice_fraction_03_a
    # trade.raw_price                 = String::new self.price_03
    trade.raw_principal             = String::new self.principal_04
    trade.raw_quantity              = String::new self.quantity_03
    trade.security_description_1    = String::new self.security_description_line_05_a.strip
    trade.security_description_2    = String::new self.security_description_line_05_b.strip
    trade.security_type             = String::new self.security_type_02
    trade.settle_date               = String::new self.settlement_date_01
    trade.solicitation_code         = String::new self.solicited_code_10
    trade.symbol                    = String::new self.symbol_02.strip
    trade.trade_date                = String::new self.trade_date_01
    trade.trade_reference_number    = String::new self.trade_reference_number_01
    trade.trade_definition_trade_id = String::new self.trade_definition_trade_id_12
    return trade
  end

end
