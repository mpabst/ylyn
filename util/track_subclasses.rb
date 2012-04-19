module TrackSubclasses
  def subclasses
    @@subclasses ||= { }
  end

  def inherited(sub)
    subclasses[sub.name] = sub
  end

  alias types subclasses
end
