module EasyStyle
  class ::String
    def to_cls(classes = nil)
      EasyStyle.cls(self, classes)
    end
  end
end
