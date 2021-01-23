class Tag
  class Params
    def self.to_save(params)
      params.require(:tag).permit(:name, :active)
    end
  end
end
