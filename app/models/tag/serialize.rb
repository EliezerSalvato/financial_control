class Tag
  class Serialize
    def self.as_json(tag)
      tag.as_json(except: [:user_id], methods: :description)
    end

    class AsJson < Micro::Case
      attribute :tag

      validates :tag, kind: Tag

      def call!
        return Success { { data: Serialize.as_json(tag) } } if tag.valid?

        Failure(:invalid_tag) { { errors: tag.errors.as_json } }
      end
    end
  end
end
