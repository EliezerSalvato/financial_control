class Api::V1::IncomesController < ApplicationController
  def index
    Income::Fetch
      .call(user: current_user, params: params)
      .then { |result| use_scopes(result) }
      .then(Income::Paginatable)
      .on_success { |result| render_json(200, result[:data]) }
  end

  def show
    Income::Find
      .call(user: current_user, income_id: params[:id])
      .then(Income::Serialize::AsJson)
      .on_failure(:income_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_income) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def create
    Income::Create
      .call(user: current_user, params: params)
      .then(Income::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:invalid_income) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(201, result[:data]) }
  end

  def update
    Income::Update
      .call(user: current_user, income_id: params[:id], params: params)
      .then(Income::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:income_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_income) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def destroy
    Income::Destroy
      .call(user: current_user, income_id: params[:id])
      .then(Income::Serialize::AsJson)
      .on_failure(:income_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_income) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  private

  def use_scopes(result)
    result.value[:data] = apply_scopes(result.value[:data])
    result
  end
end
