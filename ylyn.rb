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
      @builder.text(sexp) unless sexp.nil?
    elsif sexp.empty?
      @builder.__
    elsif sexp.first.is_a?(Array)
    # container array
      @builder.__ { sexp.each{|s| build(s) } }
    elsif sexp.first.to_s[0] == '@'
    # literal
      @builder.send(sexp[0].to_s.sub('@', '_'), value: sexp[1], location: sexp[2] * ' ')
    else
    # compound expression
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
