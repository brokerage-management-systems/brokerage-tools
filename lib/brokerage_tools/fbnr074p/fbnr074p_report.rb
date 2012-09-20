
# == Schema Information
#
# Table name: fbnr074p_reports
#
#  id               :integer(4)      not null, primary key
#  amount_of_trades :integer(4)      not null
#  branch           :string(3)       not null
#  broker_id        :string(6)       not null
#  clearing         :decimal(12, 2)  not null
#  commission       :decimal(12, 2)  not null
#  payroll_month    :date            not null
#  concession       :decimal(12, 2)  not null
#  concession_away  :decimal(12, 2)  not null
#  execution        :decimal(12, 2)  not null
#  payout           :decimal(12, 2)  not null
#  created_at       :datetime        not null
#  created_by       :integer(4)      not null
#

class Fbnr074pReport < ActiveRecord::Base

   validates_uniqueness_of :payroll_month, :scope => [:branch, :broker_id]

end

