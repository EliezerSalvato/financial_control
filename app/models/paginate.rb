class Paginate < Micro::Case
  attribute :params
  attribute :relation
  attribute :serialize

  def call!
    scoped_relation = relation.page(params[:page] || 1)

    if params[:show_all]
      scoped_relation = scoped_relation.per(1_000_000)
    end

    data = {
      data: serialize.collection_as_json(scoped_relation),
      paginatable: {
        current_page: scoped_relation.current_page,
        prev_page: scoped_relation.prev_page,
        next_page: scoped_relation.next_page,
        size: scoped_relation.size,
        total_count: scoped_relation.total_count,
        total_pages: scoped_relation.total_pages,
        offset_value: scoped_relation.offset_value
      }
    }

    Success { { data: data } }
  end
end
