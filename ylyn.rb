require 'ripper'
require 'nokogiri'

class Ylyn
  def initialize(arg)
    @sexp = (arg.is_a?(String) ? Ripper.sexp(arg) : arg)
    @builder = Nokogiri::XML::Builder.new
    @doc = build(@sexp).doc
  end

  def build(sexp)
    if sexp.nil? or sexp.empty?
    # noop
    elsif sexp.first.is_a?(Array)
    # container array
      @builder.__ { sexp.each{|s| build(s) } }
    elsif sexp.first.to_s[0] == '@'
    # literal
      @builder.send(sexp[0].to_s.sub('@', '_'), value: sexp[1], location: sexp[2] * ' ')
    elsif not sexp.is_a?(Array)
      @builder.text(sexp)
    else
    # compound expression
      @builder.send("#{sexp.first}_") do |_|
        sexp[1..-1].each{|s| build(s) }
      end
    end

    @builder
  end

  def method_missing(meth, *args, &block)
    @doc.send(meth, *args, &block)
  end
end
