class Api::V1::ExpensesController < ApplicationController
  def index
    Expense::Fetch
      .call(user: current_user, params: params)
      .then { |result| use_scopes(result) }
      .then(Expense::Paginatable)
      .on_success { |result| render_json(200, result[:data]) }
  end

  def show
    Expense::Find
      .call(user: current_user, expense_id: params[:id])
      .then(Expense::Serialize::AsJson)
      .on_failure(:expense_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_expense) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def create
    Expense::Create
      .call(user: current_user, params: params)
      .then(Expense::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:invalid_expense) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(201, result[:data]) }
  end

  def update
    Expense::Update
      .call(user: current_user, expense_id: params[:id], params: params)
      .then(Expense::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:expense_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_expense) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def destroy
    Expense::Destroy
      .call(user: current_user, expense_id: params[:id])
      .then(Expense::Serialize::AsJson)
      .on_failure(:expense_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_expense) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def last_expense
    Expense::FindLastExpense
      .call(user: current_user)
      .then(Expense::Serialize::AsJson)
      .on_failure(:expense_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_expense) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  private

  def use_scopes(result)
    result.value[:data] = apply_scopes(result.value[:data])
    result
  end
end
