# == Schema Information
#
# Table name: full_account_level_name_and_addresses
#
#  id                                                    :integer(4)      not null, primary key
#  record_type                                           :string(2)
#  record_key_client                                     :string(3)
#  branch_number                                         :string(3)
#  account_number                                        :string(5)
#  number_of_confirms                                    :string(1)
#  number_of_statements                                  :string(1)
#  registered_rep_number                                 :string(3)
#  account_type_table_type_1                             :string(1)
#  account_type_table_type_2                             :string(1)
#  account_type_table_type_3                             :string(1)
#  account_type_table_type_4                             :string(1)
#  account_type_table_type_5                             :string(1)
#  account_type_table_type_6                             :string(1)
#  account_type_table_type_7                             :string(1)
#  account_type_table_type_8                             :string(1)
#  account_type_table_type_9                             :string(1)
#  account_type_table_type_0                             :string(1)
#  debit_margin_rate                                     :string(5)
#  debit_margin_type                                     :string(1)
#  credit_margin_rate                                    :string(1)
#  credit_margin_type                                    :string(1)
#  reserved_field_00                                     :string(9)
#  reserved_field_01                                     :string(1)
#  dividend_indicator                                    :string(1)
#  buy_code                                              :string(2)
#  sell_code                                             :string(2)
#  account_classification_code                           :string(2)
#  new_york_state_resident_code                          :string(1)
#  zip_plus_4                                            :string(9)
#  geographic_location_code                              :string(3)
#  commission_bond_code                                  :string(1)
#  commission_stock_code                                 :string(1)
#  foreign_witholding_rate_stock                         :string(3)
#  foreign_witholding_rate_bonds                         :string(3)
#  last_name_pointer                                     :string(2)
#  last_name_length                                      :string(2)
#  psr_olts_cbi                                          :string(1)
#  trust_papers                                          :string(1)
#  margin_agreement                                      :string(1)
#  joint_agreement                                       :string(1)
#  loan_agreement                                        :string(1)
#  guaranty_instructions                                 :string(1)
#  sweep_code                                            :string(1)
#  auto_cash_management_instructions                     :string(1)
#  tax_equity_and_fiscal_responsibility_act_instructions :string(1)
#  general_trading_option                                :string(1)
#  restriction_indicator                                 :string(1)
#  no_more_business_indicator                            :string(1)
#  option_purpose_code                                   :string(1)
#  naked_option_code                                     :string(1)
#  number_of_interested_parties                          :string(1)
#  depository_trust_co_id_number                         :string(5)
#  type_3_credit_income_option                           :string(1)
#  option_approval_date                                  :string(4)
#  last_commodity_settlement                             :string(6)
#  guaranteed_account_number                             :string(8)
#  dividend_buy_fraction_code                            :string(1)
#  settle_office                                         :string(3)
#  date_of_birth                                         :string(6)
#  insurance_code                                        :string(1)
#  ab_sweep_code                                         :string(1)
#  ab_reinvestment_code                                  :string(1)
#  ab_redeem_code                                        :string(1)
#  tax_equity_and_fiscal_responsibility_act_update_date  :string(6)
#  objection_code                                        :string(1)
#  individual_non_individual_code                        :string(1)
#  broker_book_indicator                                 :string(1)
#  n_a_line_pointer                                      :string(1)
#  n_a_line_pointer_for_mailing_address                  :string(1)
#  n_a_line_pointer_for_city_and_state                   :string(1)
#  ab_sweep_code_2_3                                     :string(2)
#  line_pointer_for_joint_account                        :string(1)
#  address_location                                      :string(3)
#  length_of_city                                        :string(3)
#  year_end_record_indicator                             :string(1)
#  reserved_field_02                                     :string(9)
#  reserved_field_03                                     :string(1)
#  option_account_code                                   :string(1)
#  reserved_field_04                                     :string(6)
#  due_diligence_code                                    :string(1)
#  irs_indicator                                         :string(1)
#  ira_keogh_indicator                                   :string(1)
#  scratch_pad_indicator                                 :string(1)
#  due_diligence_1st_date                                :string(6)
#  date_account_opened                                   :string(6)
#  date_of_last_change                                   :string(6)
#  date_of_90_day_restriction                            :string(6)
#  profit_center_branch                                  :string(3)
#  currency_code                                         :string(3)
#  service_change                                        :string(1)
#  language_code                                         :string(1)
#  invoice_confirm_code                                  :string(1)
#  mailing_list_code                                     :string(1)
#  net_payment_to_registered_rep                         :string(3)
#  number_of_account_title_lines                         :string(1)
#  id_interested_party_1_stm9                            :string(1)
#  id_interested_party_2_stm9                            :string(1)
#  id_interested_party_1_stm6                            :string(1)
#  id_interested_party_1_stm8                            :string(1)
#  phone_number                                          :string(13)
#  related_account_code                                  :string(1)
#  related_account_number                                :string(8)
#  number_of_principal_parties_address_lines             :string(1)
#  principal_party_information_line_00                   :string(30)
#  principal_party_information_line_01                   :string(30)
#  principal_party_information_line_02                   :string(30)
#  principal_party_information_line_03                   :string(30)
#  principal_party_information_line_04                   :string(30)
#  principal_party_information_line_05                   :string(30)
#  e_confirm_indicator_00                                :string(1)
#  e_confirm_indicator_01                                :string(1)
#  class_code                                            :string(4)
#  sub_class_code                                        :string(4)
#  cash_check_digit                                      :string(1)
#  margin_check_digit                                    :string(1)
#  dividend_check_digit                                  :string(1)
#  tefra_withholding_digit                               :string(1)
#  short_sale_check_digit                                :string(1)
#  specialist_subscript_check_digit                      :string(1)
#  specialist_situations_employee_check_digit            :string(1)
#  commodities_check_digit                               :string(1)
#  delivery_vs_payment                                   :string(1)
#  individual_check_digit                                :string(1)
#  reserved_field_05                                     :string(13)
#  closing_methodology                                   :string(2)
#  mutual_fund_average_cost_date                         :string(8)
#  reserved                                              :string(21)
#  acronym                                               :string(8)
#  access_code                                           :string(12)
#  rep_name                                              :string(22)
#  trader_number                                         :string(3)
#  trader_name                                           :string(22)
#  over_the_counter_number                               :string(3)
#  over_the_counter_name                                 :string(30)
#  depository_trust_co_box                               :string(3)
#  base_number                                           :string(5)
#  customer_number                                       :string(15)
#  annual_income                                         :string(15)
#  net_worth                                             :string(15)
#  investment_objective                                  :string(1)
#  verification_date                                     :string(8)
#  occd_code                                             :string(1)
#  wrap_indicator                                        :string(12)
#  relationship_banking_indicator                        :string(1)
#  reserved_field_06                                     :string(29)
#  anti_money_laundering_disclosure_flay                 :string(1)
#  publicly_traded                                       :string(1)
#  affiliation_with_parent_entity                        :string(1)
#  public_symbol_code                                    :string(12)
#  exchange_code                                         :string(1)
#  exchange_sub_code                                     :string(4)
#  parent_organization_name                              :string(30)
#  regulator_type                                        :string(1)
#  regulator_sub_type                                    :string(4)
#  regulator_name                                        :string(30)
#  risk_jusidiction_code                                 :string(1)
#  second_investment_objective_code                      :string(1)
#  offshore_license                                      :string(1)
#  prior_business                                        :string(1)
#  bearer_share                                          :string(1)
#  fiscal_year_month                                     :string(2)
#  reserved_field_07                                     :string(2)
#  anti_money_laundering_risk_code                       :string(2)
#  platform_code                                         :string(2)
#  account_purpose                                       :string(1)
#  manager_id                                            :string(5)
#  account_benchmark_code_1                              :string(5)
#  account_benchmark_code_2                              :string(5)
#  account_benchmark_code_3                              :string(5)
#  investment_style                                      :string(3)
#  product_id                                            :string(5)
#  commence                                              :string(8)
#  termination_date                                      :string(8)
#  document_code                                         :string(90)
#  customer_legal_address_data_street_address_1          :string(30)
#  customer_legal_address_data_street_address_2          :string(30)
#  customer_legal_address_data_apartment                 :string(4)
#  customer_legal_address_data_suite                     :string(4)
#  customer_legal_address_data_city                      :string(20)
#  customer_legal_address_data_state                     :string(2)
#  customer_legal_address_data_province                  :string(4)
#  customer_legal_address_data_postal_zip_code           :string(15)
#  customer_legal_address_data_post_office_box           :string(6)
#  customer_legal_address_data_country                   :string(25)
#  goods_service_flag                                    :string(1)
#  pursuant_flag                                         :string(1)
#  exempt_flag                                           :string(1)
#  liquid_net_equity                                     :string(15)
#  source_wealth                                         :string(10)
#  source_assets                                         :string(10)
#  reserved_field_08                                     :string(289)
#  created_at                                            :datetime        not null
#  updated_at                                            :datetime        not null
#  as_of_date                             :string(8)
#

class FullAccountLevelNameAndAddress < ActiveRecord::Base

# security (i.e. attr_accessible) ...........................................
  # attr_accessible :title, :body
  
# validations ...............................................................

  validate :unique_record

# class methods .............................................................

  def self.as_of_date_to_date str
    Date.strptime(str, '%m/%d/%y')
  end

# private instance methods ..................................................

  private

  def unique_record
    unless FullAccountLevelNameAndAddress.where(:as_of_date => read_attribute(:as_of_date), :record_type => read_attribute(:record_type), :branch_number => read_attribute(:branch_number), :account_number => read_attribute(:account_number)).first.nil?
      errors.add(:as_of_date, "Record already exists: #{as_of_date}: #{record_type} | #{branch_number}-#{account_number}")
    end
  end
end
