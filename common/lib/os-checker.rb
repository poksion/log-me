# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

module OsChecker

  def run_on_windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def run_on_mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def run_on_unix?
    !run_on_windows?
  end

  def run_on_linux?
    run_on_unix? and not run_on_mac?
  end
end