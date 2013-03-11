require 'pathname'

module Ec2ssh
  class SshConfig
    HEADER = "### EC2SSH BEGIN ###"
    FOOTER = "### EC2SSH END ###"

    attr_reader :path

    def initialize(path=nil)
      @path = Pathname(path || "#{ENV['HOME']}/.ssh/config")
    end

    def append_mark!
      replace! ""
      open(@path, "a") do |f|
        f.puts wrap("")
      end
    end

    def mark_exist?
      config_src =~ /#{HEADER}\n.*#{FOOTER}\n/m
    end

    def replace!(str)
      save! config_src.gsub(/#{HEADER}\n.*#{FOOTER}\n/m, str)
    end

    def config_src
      @config_src ||= open(@path, "r") do |f|
        f.read
      end
    end

    def save!(str)
      open(@path, "w") do |f|
        f.puts str
      end
    end

    def wrap(text)
      return <<-END
#{HEADER}
# Generated by ec2ssh http://github.com/mirakui/ec2ssh
# DO NOT edit this block!
# Updated #{Time.now.iso8601}
#{text}
#{FOOTER}
      END
    end
  end
end
