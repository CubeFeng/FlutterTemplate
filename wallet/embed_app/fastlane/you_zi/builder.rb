require 'base64'
require 'yaml'
require 'fileutils'

module YouZi
  # builder tool
  class Builder
    # get version number
    def version
      'steadfast'
    end

    # @return [String] a string representation that includes the deployment
    #         target.
    #
    def self.build(name, message)
      "build name: #{name} #{message}"
    end
  end
end
