
# == Schema Information
#
# Table name: trade_revenue_trade_date_trailers
#
#  id                 :integer(4)      not null, primary key
#  clearing_charge    :decimal(12, 2)  not null
#  commission         :decimal(12, 2)  not null
#  concession         :decimal(12, 2)  not null
#  logical_records    :integer(4)      not null
#  logical_records_ht :integer(4)      not null
#  principal          :decimal(12, 2)  not null
#  run_date           :date            not null
#

class TradeRevenueTradeDateTrailer < ActiveRecord::Base

  has_many :trade_revenue_trade_date_trades, :class_name => 'TradeRevenueTradeDateTrade', :primary_key => 'run_date', :foreign_key => 'run_date_01', :order => "id ASC"

  validates_uniqueness_of :run_date

end

