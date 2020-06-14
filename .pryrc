def r; reload!; end
def c; system('clear'); end
def cont; continue; end

def pbcopy(data)
  out = data.is_a?(String) ? data : data.inspect

  IO.popen('tr -d "\n" | pbcopy', 'w') do |io|
    io.puts(out)
  end
end
