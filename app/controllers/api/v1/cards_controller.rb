class Api::V1::CardsController < ApplicationController
  def index
    Card::Fetch
      .call(user: current_user, params: params)
      .then { |result| use_scopes(result) }
      .then(Card::Paginatable)
      .on_success { |result| render_json(200, result[:data]) }
  end

  def show
    Card::Find
      .call(user: current_user, card_id: params[:id])
      .then(Card::Serialize::AsJson)
      .on_failure(:card_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_card) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def create
    Card::Create
      .call(user: current_user, params: params)
      .then(Card::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:invalid_card) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(201, result[:data]) }
  end

  def update
    Card::Update
      .call(user: current_user, card_id: params[:id], params: params)
      .then(Card::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:card_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_card) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def destroy
    Card::Destroy
      .call(user: current_user, card_id: params[:id])
      .then(Card::Serialize::AsJson)
      .on_failure(:card_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_card) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  private

  def use_scopes(result)
    result.value[:data] = apply_scopes(result.value[:data])
    result
  end
end
