class Group::Serialize
  def self.as_json(group)
    group.as_json(except: [:user_id], methods: :description)
  end

  class AsJson < Micro::Case
    attribute :group

    validates :group, kind: Group

    def call!
      return Success { { data: Group::Serialize.as_json(group) } } if group.valid?

      Failure(:invalid_group) { { errors: group.errors.as_json } }
    end
  end

  class PaginatedRelationAsJson < Micro::Case
    attribute :relation

    validates :relation, kind: ActiveRecord::Relation

    def call!
      paginatable = {
        current_page: relation.current_page,
        prev_page: relation.prev_page,
        next_page: relation.next_page,
        size: relation.size,
        total_count: relation.total_count,
        total_pages: relation.total_pages,
        offset_value: relation.offset_value
      }

      data = relation.map { |group| Group::Serialize.as_json(group) }

      Success(data: { data: data, paginatable: paginatable })
    end
  end
end
