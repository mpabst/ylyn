require 'ripper'
require 'nokogiri'

class Ylyn
  def initialize(arg)
    @sexp = (arg.is_a?(String) ? Ripper.sexp(arg) : arg)
    @builder = Nokogiri::XML::Builder.new
    @doc = build(@sexp).doc
  end

  def build(sexp)
    if not sexp.is_a?(Array)
    # #text() will take nil, but it fucks up the XML's indentation for some reason
      @builder.op(class: sexp) unless sexp.nil?
    elsif sexp.empty?
    # build an empty, "anonymous" <_/> node
      @builder.__
    elsif sexp.first.is_a?(Array)
    # container array - use <_>
      @builder.__ { sexp.each{|s| build(s) } }
    elsif sexp.first.to_s[0] == '@'
    # literal
    # substitute leading @s with _s - I'm guessing most XML tools will be happier that way
      @builder.send(sexp[0].to_s.sub('@', '_'), class: sexp[1], loc: sexp[2] * ' ')
    else
    # compound expression - Nokogiri uses the trailing _ to disambiguate from core Ruby
    # methods; _ itself is dropped in built XML
      @builder.send("#{sexp.first}_") do |_|
        sexp[1..-1].each{|s| build(s) }
      end
    end

    @builder
  end

  def method_missing(method, *args, &block)
    @doc.send(method, *args, &block)
  end

  def respond_to?(method)
    super or @doc.respond_to?(method)
  end

end
