class Group
  module FindAll
    WithPagination = Micro::Case::Flow([
      ByUser,
      FilterByParams,
      Paginate
    ])
  end
end
