class Group::Destroy < Micro::Case
  flow Group::Find,
       self.call!

  attribute :group

  validates :group, kind: Group

  def call!
    group.destroy if group.valid?

    Success { attributes }
  end
end
