#!/usr/bin/env ruby

require 'pp'

fields = %w(repo loc num_classes num_public_methods public_with_explicit_throws
public_with_explicit_throws_percent nonpublic_methods
nonpublic_with_explicit_throws nonpublic_with_explicit_throws
num_throw_statements num_try num_catch throw_on_catch return_on_catch
log_on_catch num_finally throw_on_finally return_on_finally log_on_finally
)

puts fields.join(',')

Dir['*.txt'].map do |file|
  contents = File.open(file).read.split(/\n/)

  next if contents.empty?

  up_to = contents.find_index { |x| x.start_with? 'Most Frequently caught' }

  contents[0..(up_to - 1)].reduce({}) do |acc, line|
    unless line.start_with? '-----'

      var, val = line.split(/:/)
      var = var.strip.downcase
      var = var.tr '-', ''
      val = val.strip.downcase

      if var == 'system'
        var = 'repo'
        val = val.split(/\//)[1]
        val = val.tr '@', '/'
      end
      acc[var] = val
    end
    acc
  end
end.select do |x|
  !x.nil?
end.each do |x|
  puts fields.map{ |f| x[f].to_s }.join(',')
end
