#!/usr/bin/env ruby
def multiples_of(val, below_val)
  [].tap {|a| ((below_val - 1) / val).times {|i| a << (i + 1) * val}}
end
below_val = 1000
puts (multiples_of(3, below_val) + multiples_of(5, below_val)).uniq.inject(&:+)