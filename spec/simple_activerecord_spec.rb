# Generated by generate.rb
require 'helper'

describe_juno "simple_activerecord" do
  def new_store
    Juno.new(:ActiveRecord, :connection => { :adapter => (defined?(JRUBY_VERSION) ? 'jdbcsqlite3' : 'sqlite3'), :database => File.join(make_tempdir, 'simple_activerecord') }, :logger => true, :logout => File.open(File.join(make_tempdir, 'simple_activerecord.log'), 'a'))
  end

  include_context 'setup_store'
  it_should_behave_like 'null_objectkey_objectvalue'
  it_should_behave_like 'null_objectkey_stringvalue'
  it_should_behave_like 'null_objectkey_hashvalue'
  it_should_behave_like 'null_stringkey_objectvalue'
  it_should_behave_like 'null_stringkey_stringvalue'
  it_should_behave_like 'null_stringkey_hashvalue'
  it_should_behave_like 'null_hashkey_objectvalue'
  it_should_behave_like 'null_hashkey_stringvalue'
  it_should_behave_like 'null_hashkey_hashvalue'
  it_should_behave_like 'store_objectkey_objectvalue'
  it_should_behave_like 'store_objectkey_stringvalue'
  it_should_behave_like 'store_objectkey_hashvalue'
  it_should_behave_like 'store_stringkey_objectvalue'
  it_should_behave_like 'store_stringkey_stringvalue'
  it_should_behave_like 'store_stringkey_hashvalue'
  it_should_behave_like 'store_hashkey_objectvalue'
  it_should_behave_like 'store_hashkey_stringvalue'
  it_should_behave_like 'store_hashkey_hashvalue'
  it_should_behave_like 'returndifferent_objectkey_objectvalue'
  it_should_behave_like 'returndifferent_objectkey_stringvalue'
  it_should_behave_like 'returndifferent_objectkey_hashvalue'
  it_should_behave_like 'returndifferent_stringkey_objectvalue'
  it_should_behave_like 'returndifferent_stringkey_stringvalue'
  it_should_behave_like 'returndifferent_stringkey_hashvalue'
  it_should_behave_like 'returndifferent_hashkey_objectvalue'
  it_should_behave_like 'returndifferent_hashkey_stringvalue'
  it_should_behave_like 'returndifferent_hashkey_hashvalue'
  it_should_behave_like 'marshallable_key'
end
