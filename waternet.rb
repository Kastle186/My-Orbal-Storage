#!/usr/bin/ruby

# Added this little comment woo!

require 'fileutils'
require 'pathname'

WATERNET_WORK_LOCAL_ENV_VAR = "WATERNET_WORK_LOCAL"
WATERNET_WORK_REMOTE_ENV_VAR = "WATERNET_WORK_REMOTE"

WATERNET_WORK_LOCAL = ENV[WATERNET_WORK_LOCAL_ENV_VAR]
WATERNET_WORK_REMOTE = ENV[WATERNET_WORK_REMOTE_ENV_VAR]

WATERNET_LOG_TABLE_FILE = "#{WATERNET_WORK_LOCAL}/checkin_checkout_logtable.txt"
WATERNET_CHECKED_OUT_FILES = File.exist?(WATERNET_LOG_TABLE_FILE) \
                             ? File.readlines(WATERNET_LOG_TABLE_FILE, chomp: true) \
                             : Array.new

# TODO: I'm almost sure that we can refactor a bit to clean some code in the
#       checkout/checkin/restore functions.

def checkout(path)
  if checked_out?(path)
    puts "The requested file #{path} has already been checked out."
    return
  end

  unless File.exist?(path)
    puts "The requested file to checkout #{path} was not found :("
    return
  end

  tree_path = path.relative_path_from(WATERNET_WORK_REMOTE)
  local_dest = "#{WATERNET_WORK_LOCAL}/#{tree_path}"

  FileUtils.copy_entry(path, local_dest, remove_destination: true)
  add_entry_to_logtable(path.to_s)
  puts "Checked out #{File.basename(path)}!"
end

def checkin(path)
  unless checked_out?(path)
    puts "The requested file to checkin #{path} has not been checked out :("
    return
  end

  tree_path = path.relative_path_from(WATERNET_WORK_LOCAL)
  remote_dest = "#{WATERNET_WORK_REMOTE}/#{tree_path}"

  FileUtils.copy_entry(path, remote_dest, remove_destination: true)
  remove_entry_from_logtable(path.to_s)
  puts "Checked in #{File.basename(path)}!"
end

def restore(path)
  unless checked_out?(path)
    puts "The requested file to checkin #{path} has not been checked out :("
    return
  end

  tree_path = path.relative_path_from(WATERNET_WORK_LOCAL)
  original_src = "#{WATERNET_WORK_REMOTE}/#{tree_path}"

  FileUtils.copy_entry(original_src, path, remove_destination: true)
  remove_entry_from_logtable(path)
  puts "Restored #{File.basename(path)}!"
end

def add_entry_to_logtable(pathstr)
  WATERNET_CHECKED_OUT_FILES << pathstr

  File.open(WATERNET_LOG_TABLE_FILE, 'a') do |f|
    WATERNET_CHECKED_OUT_FILES.each { |entry| f.puts(entry) }
  end
end

def remove_entry_from_logtable(pathstr)
  WATERNET_CHECKED_OUT_FILES.delete(pathstr)

  File.open(WATERNET_LOG_TABLE_FILE, 'w') do |f|
    WATERNET_CHECKED_OUT_FILES.each { |entry| f.puts(entry) }
  end
end

def checked_out?(path)
  WATERNET_CHECKED_OUT_FILES.include?(path.to_s)
end

if (WATERNET_WORK_LOCAL.nil?)
  puts "The WATERNET_WORK_LOCAL environment variable has not been set. Set it to" \
       " the local version of the work tree and then try again."
  exit -1
end

if (WATERNET_WORK_REMOTE.nil?)
  puts "The WATERNET_WORK_REMOTE environment variable has not been set. Set it to" \
       " the remote/base version of the work tree and then try again."
  exit -1
end

# TODO: Add checks to ensure we actually got enough arguments.
#       Also, adding a small help would be great.

op, path = ARGV
fullpath = Pathname.new(File.absolute_path(path))

case op
when 'checkout' then checkout(fullpath)
when 'checkin'  then checkin(fullpath)
when 'restore'  then restore(fullpath)
end
