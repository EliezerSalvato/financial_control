class Api::V1::GroupsController < ApplicationController
  def index
    Group::FindAllForUser
      .call(user: current_user, params: params)
      .then(Paginate)
      .then(Serialize::PaginatedRelationAsJson, serializer: Group::Serialize)
      .on_success { |result| render_json(200, result) }
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
end
