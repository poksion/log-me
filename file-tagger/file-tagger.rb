# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

require_relative 'lib/tagger-builder'

def build_tagger(config_filename)
  tagger_builder = TaggerBuilder.new(config_filename)
  tagger_builder.build()
end

# file-tagger
#  - default config reporting
# file-tagger config-name
# file-tagger compare result1 result2

if __FILE__ == $0

  valid_argv = true
  total_build_mode = true
  config_file = ""

  if ARGV.length == 0
    config_file = ""
  elsif ARGV.length == 1
    config_file = ARGV[0]
  else
    valid_argv = false
  end
  
  unless valid_argv
    puts "ruby file-tagger"
    puts "ruby file-tagger config-file.yml"
    return
  end
  
  if total_build_mode
    build_tagger(config_file)
  end

end
