# encoding: utf-8
# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2:

class FileTaggerShell
  def initialize(action, file)
    @action = action
    @file = file
  end

  def get_response()
    "미구현-" + @action
  end
end
