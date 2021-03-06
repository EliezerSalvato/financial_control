class Api::V1::TagsController < ApplicationController
  def index
    Tag::FindAllForUser
      .call(user: current_user, params: params)
      .then(Paginate)
      .then(Serialize::PaginatedRelationAsJson, serializer: Tag::Serialize)
      .on_success { |result| render_json(200, result) }
  end

  def show
    Tag::Find
      .call(user: current_user, tag_id: params[:id])
      .then(Tag::Serialize::AsJson)
      .on_failure(:tag_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_tag) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def create
    Tag::Create
      .call(user: current_user, params: params)
      .then(Tag::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:invalid_tag) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(201, result[:data]) }
  end

  def update
    Tag::Update
      .call(user: current_user, tag_id: params[:id], params: params)
      .then(Tag::Serialize::AsJson)
      .on_failure(:parameter_missing) { |error| render_json(400, error: error[:message]) }
      .on_failure(:tag_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_tag) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end

  def destroy
    Tag::Destroy
      .call(user: current_user, tag_id: params[:id])
      .then(Tag::Serialize::AsJson)
      .on_failure(:tag_not_found) { render_json(404, error: { id: 'not found' }) }
      .on_failure(:invalid_tag) { |error| render_json(422, error: error[:errors]) }
      .on_success { |result| render_json(200, result[:data]) }
  end
end
