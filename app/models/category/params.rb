class Category::Params
  def self.to_save(params)
    params.require(:category).permit(:name, :active)
  end
end
