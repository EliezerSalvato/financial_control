class Api::V1::GroupsController < ApplicationController
  def index
    Group::Fetch
      .call(user: current_user, params: params)
      .then { |result| use_scopes(result) }
      .then(Group::Paginatable)
      .on_success { |result| render_json(200, result[:data]) }
  end

  def show
    Group::Find
      .call(user: current_user, group_id: params[:id])
      .then(Group::Serialize::AsJson)
      .on_failure(:group_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_group) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def create
    Group::Create
      .call(user: current_user, params: params)
      .then(Group::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:invalid_group) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(201, result[:data]) }
  end

  def update
    Group::Update
      .call(user: current_user, group_id: params[:id], params: params)
      .then(Group::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:group_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_group) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def destroy
    Group::Destroy
      .call(user: current_user, group_id: params[:id])
      .then(Group::Serialize::AsJson)
      .on_failure(:group_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_group) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  private

  def use_scopes(result)
    result.value[:data] = apply_scopes(result.value[:data])
    result.value[:data] = result.value[:data].per(current_user.groups.count) if params[:show_all]
    result
  end
end
