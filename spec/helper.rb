require 'moneta'
require 'fileutils'
require 'monetaspecs'
require 'rspec/core/formatters/progress_formatter'

RSpec::Core::Formatters::ProgressFormatter.class_eval do
  def example_passed(example)
    # do nothing
  end
end

class Value
  attr_accessor :x
  def initialize(x)
    @x = x
  end

  def ==(other)
    Value === other && other.x == x
  end

  def eql?(other)
    Value === other && other.x == x
  end

  def hash
    x.hash
  end
end

def start_restserver
  require 'rack'
  require 'webrick'
  require 'httpi'
  require 'rack/moneta_rest'

  HTTPI.log = false

  # Keep webrick quiet
  ::WEBrick::HTTPServer.class_eval do
    def access_log(config, req, res); end
  end
  ::WEBrick::BasicLog.class_eval do
    def log(level, data); end
  end

  Thread.start do
    Rack::Server.start(:app => Rack::Builder.app do
                         use Rack::Lint
                         map '/moneta' do
                           run Rack::MonetaRest.new(:store => :Memory)
                         end
                       end,
                       :environment => :none,
                       :server => :webrick,
                       :Port => 8808)
  end
  sleep 1
end

def start_server(*args)
  server = Moneta::Server.new(*args)
  Thread.new { server.run }
  sleep 0.1 until server.running?
rescue Exception => ex
  puts "Failed to start server - #{ex.message}"
end

def make_tempdir
  # Expand path since datamapper needs absolute path in setup
  tempdir = File.expand_path(File.join(File.dirname(__FILE__), 'tmp'))
  FileUtils.mkpath(tempdir)
  tempdir
end

def marshal_error
  # HACK: Marshalling structs in rubinius without class name throws
  # NoMethodError (to_sym). TODO: Create an issue for rubinius!
  if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    RUBY_VERSION < '1.9' ? ArgumentError : NoMethodError
  else
    TypeError
  end
end

class InitializeStore
  def initialize(&block)
    instance_eval(&block)
    store = new_store
    store['foo'] = 'bar'
    store.clear
    store.close
  end

  def method_missing(*args)
  end
end

def describe_moneta(name, &block)
  begin
    InitializeStore.new(&block)
    describe(name, &block)
  rescue LoadError => ex
    puts "\e[31mTest #{name} not executed: #{ex.message}\e[0m"
  rescue Exception => ex
    puts "\e[31mTest #{name} not executed: #{ex.message}\e[0m"
    puts ex.backtrace.join("\n")
  end
end

shared_context 'setup_store' do
  def store
    @store ||= new_store
  end

  before do
    store.clear
  end

  after do
    store.close.should == nil if store
  end
end
