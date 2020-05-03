class Group::Params
  def self.to_save(params)
    params.require(:group).permit(:name, :active)
  end
end
