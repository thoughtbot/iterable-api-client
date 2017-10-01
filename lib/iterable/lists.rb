module Iterable
  ##
  #
  # Interact with /lists API endpoints
  #
  # @example Creating list endpoint object
  #   # With default config
  #   lists = Iterable::Lists.new
  #   lists.all
  #
  #   # With custom config
  #   conf = Iterable::Config.new(token: 'new-token')
  #   lists = Iterable::Lists.new(config)
  class Lists < ApiResource
    ##
    #
    # Get all lists
    #
    # @return [Iterable::Response] A response object
    def all
      Iterable.request(conf, '/lists').get
    end

    ##
    #
    # Create a new list with a name
    #
    # @param name [String] The name of the list to create
    #
    # @return [Iterable::Response] A response object
    def create(name)
      Iterable.request(conf, '/lists').post(name: name)
    end
  end
end
