class Api::V1::HomeController < ApplicationController
  def incomes
    Income::MonthlyIncome::Fetch
      .call(user: current_user, params: params)
      .on_success { |result| render_json(200, result[:data]) }
  end

  def expenses
    Expense::MonthlyExpense::Fetch
      .call(user: current_user, params: params)
      .on_success { |result| render_json(200, result[:data]) }
  end
end
