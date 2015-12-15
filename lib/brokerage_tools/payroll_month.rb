# == Schema Information
#
# Table name: payroll_months
#
#  id             :integer(4)      not null, primary key
#  start_date     :date            not null
#  end_date       :date            not null
#  label          :string(50)      not null
#  next_month     :date            not null
#  previous_month :date            not null
#  created_at     :date            not null
#  created_by     :integer(4)      not null
#

class PayrollMonth < ActiveRecord::Base

  # relationships .............................................................

  belongs_to :broker_payroll_submission, :primary_key => 'commission_month', :foreign_key => 'end_date'

  # public instance methods ...................................................

  def month_label
    "#{label}"
  end
end
