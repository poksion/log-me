# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/tagger-builder'
require_relative 'lib/tagger-operator'

def build_tagger(config_filename)
  tagger_builder = TaggerBuilder.new(config_filename)
  tagger_builder.build()
end

def operate_tagger(op_type, op_lhs, op_rhs)
  tagger_operator = TaggerOperator.new(op_type, op_lhs, op_rhs)
  tagger_operator.show_result()
end

# result config-name
# op sub|dup|dup-summary result1 result2
# nas-to-cloud

if __FILE__ == $0

  valid_argv = true

  if ARGV.length == 2 and ARGV[0] == 'result'
    build_tagger(ARGV[1])
  elsif ARGV.length == 4 and ARGV[0] == 'op'
    operate_tagger(ARGV[1], ARGV[2], ARGV[3])
  else
    valid_argv = false
  end
  
  unless valid_argv
    puts "result config-file.yml"
    puts "op sub|dup|dup-summary result1.yml result2.yml"
    puts "local-to-cloud"
    puts "nas-to-cloud"
    puts "dev-export"
    puts "dev-import"
  end

end
