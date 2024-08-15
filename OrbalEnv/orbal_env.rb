#!/usr/bin/ruby

require 'pathname'

DIR_STACK_MAX_SIZE = 10
DIR_STACK_SEPARATOR = ';;'

def dir2stack(args)
  dir_stack = ENV["DIR_STACK"]

  if dir_stack.scan(DIR_STACK_SEPARATOR).length >= (DIR_STACK_MAX_SIZE-1)
  end

  puts dir_stack
end

def ncd(args)
  level = args[0].to_i
  return if level.zero?

  cwd = Pathname.pwd
  level.times { cwd = cwd.parent }
  puts cwd.to_s
end

def main(args)
  command = args[0]
  cmd_args = args.drop(1)
  exit_code = 0

  case command
  when 'dir2stack' then dir2stack(cmd_args)
  when 'ncd' then ncd(cmd_args)
  else
    puts "Apologies, but command #{command} is not supported yet."
    exit_code = -1
  end

  exit_code
end

main(ARGV)
