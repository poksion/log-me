OFFSET = 512

def read_head_and_tail(file_name)
  head, tail = nil, nil

  File.open(file_name) do |file|
     head = file.gets
     break unless head
  
     limit = file.stat.size
     offset = OFFSET
     lines = []

     while lines.size < 2 && offset <= limit
       file.seek(-offset, IO::SEEK_END)
       lines = file.readlines
       offset += OFFSET
     end
     
     tail = lines.last unless lines.empty?
  end
  
  return head, tail
end