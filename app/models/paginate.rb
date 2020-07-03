class Paginate < Micro::Case
  attributes :params, :relation

  def call!
    paginated_relation = relation.page(params[:page] || 1)

    if params[:show_all]
      paginated_relation = scoped_relation.per(1_000_000)
    end

    Success { { relation: paginated_relation } }
  end
end
