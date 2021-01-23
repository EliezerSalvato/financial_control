class Tag
  class Destroy < Micro::Case
    flow Find,
         self.call!

    attribute :tag

    validates :tag, kind: Tag

    def call!
      tag.destroy if tag.valid?

      Success { attributes }
    end
  end
end
