class Group::Serialize
  def self.as_json(group)
    group.as_json(except: [:user_id], methods: :description)
  end

  def self.collection_as_json(groups)
    groups.map { |group| as_json(group) }
  end

  class AsJson < Micro::Case
    attribute :group

    validates :group, kind: Group

    def call!
      return Success { { data: Group::Serialize.as_json(group) } } if group.valid?

      Failure(:invalid_group) { { errors: group.errors.as_json } }
    end
  end
end
