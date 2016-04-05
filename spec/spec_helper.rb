$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bosh_aliyun_cpi'
require 'yaml'

def load_client_options
  {:access_key_id => ENV['ACCESS_KEY_ID'], :secret => ENV['SECRET']}
end

def load_cloud_options
  o = YAML.load_file('spec/assets/cpi_config')

  recursive_symbolize_keys o
end

def recursive_symbolize_keys(h)
  case h
  when Hash
    Hash[
      h.map do |k, v|
        [ k.respond_to?(:to_sym) ? k.to_sym : k, recursive_symbolize_keys(v) ]
      end
    ]
  when Enumerable
    h.map { |v| recursive_symbolize_keys(v) }
  else
    h
  end
end

RSpec.configure do |config|
  config.before do
    logger = Logger.new('/dev/null')
    allow(Bosh::Clouds::Config).to receive(:logger).and_return(logger)
  end
end
