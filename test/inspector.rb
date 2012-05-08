(expressions = File.read('test/expressions.rubyish').split("\n")).each do |expr|
  puts expr << "\n\n"
  puts Ripper.sexp(expr).pretty_inspect << "\n\n"
  puts Ylyn.new(expr).to_xml << "\n\n"
  puts "\n\n"
end; ''
