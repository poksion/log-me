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

# file-tagger
#  - default config reporting
# file-tagger config-name
# file-tagger compare result1 result2

if __FILE__ == $0

  valid_argv = true

  if ARGV.length == 0
    build_tagger("")
  elsif ARGV.length == 1
    build_tagger(ARGV[0])
  elsif ARGV.length == 4 and ARGV[0] == 'op'
    operate_tagger(ARGV[1], ARGV[2], ARGV[3])
  else
    valid_argv = false
  end
  
  unless valid_argv
    puts "ruby file-tagger"
    puts "ruby file-tagger config-file.yml"
  end

end
