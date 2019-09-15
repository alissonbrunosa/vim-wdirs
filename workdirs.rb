#!/usr/bin/env ruby

# frozen_string_literal: true

require "fileutils"
require "optparse"
require "set"

VERSION = "0.0.1"

class Util
  class << self
    def get_home_path
      case RUBY_PLATFORM
      when /linux/
        File.join File.expand_path("~"), ".local", "share"
      when /Darwin/
        File.join File.expand_path("~"), "Library"
      when /Windows/
        ENV["APP_DATA"]
      end
    end

    def get_database_path
      File.join get_home_path, "workdirs", "data"
    end
  end
end

class WorkdirManager
  def initialize
    @database_path = Util.get_database_path
  end

  def add path
    paths = load_paths
    paths << path

    save paths
  end

  def delete path
    paths = load_paths
    paths.delete path

    save paths
  end

  def init
    if File.exists? database_path
      puts "Database already exists"
      return
    end

    base_dir = File.dirname(database_path)
    FileUtils.mkpath base_dir
    FileUtils.touch database_path

    puts "Created work directories database at: #{ database_path }"
  end

  def reset
    File.delete(database_path) if File.exist?(database_path)
    init
  end

  def print
    load_paths.each do |path|
      puts path
    end
  end

  private

  attr_reader :database_path

  def load_paths
    return Set.new unless File.exists? database_path

    paths = Set.new
    File.open database_path do |file|
      file.each_line do |line|
        paths.add line.strip
      end
    end

    paths
  end

  def save paths
    File.open(database_path, "w+") do |file|
      paths.each do |path|
        file.write "#{ path }\n"
      end

      file.flush
    end
  end
end

class Command
  def self.execute! args
    manager = WorkdirManager.new

    OptionParser.new do |opts|
      opts.on("-a", "--add PATH", "add a new work directory") do |path|
        manager.add path
      end

      opts.on("-d", "--delete PATH", "delete a work directory") do |path|
        manager.delete path
      end

      opts.on("--init", "create work directories database") do
        manager.init
      end

      opts.on("--reset", "reset work directories database") do
        manager.reset
      end

      opts.on_tail("--print", "print all work directories") do
        manager.print
      end

      opts.on_tail("--version", "diplay version information and exit") do
        puts "Version: #{ VERSION }"
        exit
      end

      opts.on_tail("-h", "--help", "display this help and exit") do
        puts opts
        exit
      end
    end.parse!(args)
  end
end

Command.execute!(ARGV)

