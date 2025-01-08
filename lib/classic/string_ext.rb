module Classic
  class ::String
    def to_cls(classes = nil)
      Classic.cls(self, classes)
    end
  end
end
