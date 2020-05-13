class Api::V1::CategoriesController < ApplicationController
  def index
    Category::Fetch
      .call(user: current_user, params: params)
      .then { |result| use_scopes(result) }
      .then(Category::Paginatable)
      .on_success { |result| render_json(200, result[:data]) }
  end

  def show
    Category::Find
      .call(user: current_user, category_id: params[:id])
      .then(Category::Serialize::AsJson)
      .on_failure(:category_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_category) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def create
    Category::Create
      .call(user: current_user, params: params)
      .then(Category::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:invalid_category) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(201, result[:data]) }
  end

  def update
    Category::Update
      .call(user: current_user, category_id: params[:id], params: params)
      .then(Category::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:category_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_category) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def destroy
    Category::Destroy
      .call(user: current_user, category_id: params[:id])
      .then(Category::Serialize::AsJson)
      .on_failure(:category_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_category) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  private

  def use_scopes(result)
    result.value[:data] = apply_scopes(result.value[:data])
    result
  end
end
