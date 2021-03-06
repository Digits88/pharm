module Pharm
  module Config
    @@admin_hash = YAML.load(File.read("#{RAILS_ROOT}/config/admin.yml"))[ENV["RAILS_ENV"]]
    @@options    = YAML.load(File.read("#{RAILS_ROOT}/config/options.yml")) || {}

    class_variables.each do |v|
      mattr_accessor v[(2..-1)]
    end
  end
end