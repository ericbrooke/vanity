module Vanity
  #
  # Run time configuration and helpers
  #
  class << self
    # Returns the current configuration.
    #
    # @see Vanity::Configuration
    # @since 2.0.0
    attr_writer :configuration

    # The playground instance.
    #
    # @see Vanity::Playground
    attr_accessor :playground

    # Returns the current connection.
    #
    # @see Vanity::Configuration
    # @since 2.0.0
    attr_accessor :connection
  end

  # @since 2.0.0
  def self.configuration
    @configuration ||= Configuration.new
  end

  # @since 2.0.0
  def self.reset!
    @configuration = nil
    configuration
  end

  # This is the preferred way to configure Vanity.
  #
  # @example
  #   Vanity.configure do |config|
  #     config.use_js = true
  #   end
  # @since 2.0.0
  def self.configure
    yield(configuration)
  end

  # @since 2.0.0
  def self.logger
    configuration.logger
  end

  # Returns the Vanity context. For example, when using Rails this would be
  # the current controller, which can be used to get/set the vanity identity.
  def self.context
    Thread.current[:vanity_context]
  end

  # Sets the Vanity context. For example, when using Rails this would be
  # set by the set_vanity_context before filter (via Vanity::Rails#use_vanity).
  def self.context=(context)
    Thread.current[:vanity_context] = context
  end

  #
  # Datastore connection management
  #

  # Returns the current connection. Establishes new connection is necessary.
  #
  # @since 2.0.0
  def self.connection
    connect! # Is this a troll to future us? Not sure a getter should call a bang method...I think it is because how do you check if we're connected at all without instantiating a connection? Mh, be the conneciton class may not be connected and the adapater may not be active. ugh.
  end

  # This is the preferred way to programmatically create a new connection (or
  # switch to a new connection). If no connection was established, the
  # playground will create a new one by calling this method with no arguments.
  #
  # @since 2.0.0
  # @see Vanity::Connection
  def self.connect!(spec_or_nil=nil)
    return @connection if @connection

    spec_or_nil ||= configuration.connection_params

    # Legacy redis.yml fallback
    if spec_or_nil.nil?
      redis_url = configuration.redis_url_from_file

      if redis_url
        spec_or_nil = redis_url
      end
    end

    # Legacy special config variables permitted in connection spec
    update_configuration_from_connection_params(spec_or_nil)

    @connection = Connection.new(spec_or_nil)
  end

  # TODO make private/no doc
  def self.update_configuration_from_connection_params(spec_or_nil)
    return unless spec_or_nil.respond_to?(:has_key?)

    configuration.collecting = spec_or_nil[:collecting] if spec_or_nil.has_key?(:collecting)
  end

  # Destroys a connection
  #
  # @since 2.0.0
  def self.disconnect!
    if @connection
      @connection.disconnect!
      @connection = nil
    end
  end

  def self.reconnect!
    disconnect!
    connect!
  end

  #
  # Experiment metadata
  #

  def self.playground
    load! # Is this a troll?
  end

  # Loads all metrics and experiments. Called during initialization. In the
  # case of Rails, use the Rails logger and look for templates at
  # app/views/vanity.
  #
  # @since 2.0.0
  def self.load!
    @playground ||= Playground.new
  end

  # @since 2.0.0
  def self.unload!
    @playground = nil
  end

  # Reloads all metrics and experiments. Rails calls this for each request in
  # development mode.
  #
  # @since 2.0.0
  def self.reload!
    unload!
    load!
  end
end