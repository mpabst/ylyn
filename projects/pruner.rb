# dead code spotter

TYPES = %w( gvars cvars ivars idents consts )

type_method_definer = -> {
  TYPES.each do |t|
    define_method(t) do 
      instance_variable_set("@#{t}") = {} unless instance_variable_get("@#{t}")
    end
  end  
}

class Defined
  class << self
    type_method_definer.call
  end
end

class Used
  class << self
    type_method_definer.call
  end
end

ARGV.each do |path|
  Dir[path].each do |file|
    xml = Ylyn.new(File.read(file))

    # methods
    ['def > _ident']
    # aliasing?
    # send?
    # define_method?
    # alias method chain

    # symbols
    ['module > _const', 'class > _const', 'module > const_path_ref > _const', 'class > const_path_ref > _const']
    # symbols on LHS of assignment
    # constantize?

    # gvars

    # cvars
    # class_variable_set

    # ivars
    # instance_variable_set

    # misc idents? - don't bother for now


  # capture at moment of definition, look for use elsewhere

  # vvv diminishing returns
  # _ident inside vs. not inside a vcall - only totes useful if params are required
  # call vs fcall vs vcall ?

  # Empty modules and methods?

  # unreachable:
  # compile an index of idents etc used in each code block:
  # - method bodies
  # - module-level code
  # - global-level code
  # start with controller actions and resque work methods and start marking identifiers via breadth-first
  # unmarked symbols, methods, and idents are probs dead
end
