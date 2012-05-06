File.open('out', 'w') do |out|
  (expressions = File.read('test/expressions.rubyish').split("\n")).each do |expr|
    out << expr << "\n\n"
    out << Ripper.sexp(expr).pretty_inspect << "\n\n"
    out << Ylyn.new(expr).to_xml << "\n\n"
    out << "\n\n"
  end
end
