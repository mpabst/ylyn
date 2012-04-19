module Node

  Location = Struct.new(:line, :column)

  class Expression
    extend TrackSubclasses

    def self.build(*args)
      node = new
      children.each_with_index do |child, i|
        node.send("#{child}=", build_subtype(args[i]))
      end
      return node
    end

    def self.build_subtype(args)
      types["Node::#{args.first.to_s.camelize}"].build(*args[1..-1])
    rescue
      debugger
      1
    end

    def self.children(*attrs)
      attr_accessor *attrs
      (@children ||= [ ]) << attrs
    end

    def children
      self.class.children.map{|c| send(c) }
    end

    attr_accessor :parent

    def descendants
      children.map(&:descendants).flatten
    end

    def ancestors
      parent ? parent.ancestors.flatten.compact.reverse : [ ]
    end

    def path
      ancestors << parent
    end
  end

  class Literal < Expression
    children :value, :location

    def self.build(value, location)
      self.value = value
      self.location = Location.new(*location)
    end
  end

  class Program < Expression
    children :expressions

    def self.build(expressions)
      self.expressions = expressions.map{|ex| Node.build(*ex) }
    end
  end

  class Class < Expression
    children :const_ref, :var_ref
    alias superclass var_ref

    def name
      const_ref.name
    end
  end

  class ConstRef < Literal
    alias name value
  end

  class VarRef < Literal
    alias name value
  end

  class Assign < Expression
    children :var_field
  end

  class VarField < Expression
    children :left, :right
  end

  class Int < Literal

  end

  class Ident < Literal

  end

end
