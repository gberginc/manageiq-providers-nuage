require 'qpid_proton'

class ManageIQ::Providers::Nuage::NetworkManager::EventCatcher::Stream
  def self.test_amqp_connection(options = {})
    # Ensure we just test the connection. AMQP channel will be established and
    # started, however it will be immediately stopped.
    options[:test_connection] = true
    begin
      container = connect(options)
      container.run
      true
    rescue => e
      $log.info("#{log_prefix} Failed connecting to ActiveMQ: #{e.message}")
      raise
    end
  end

  def self.connect(connection_options = {})
  end

  def self.log_prefix
    "MIQ(#{self.class.name})"
  end

  def initialize(options = {})
    @options           = options
    @collecting_events = false
  end

  def start(&message_handler_block)
    $log.debug("#{self.class.log_prefix} Opening amqp connection using options #{@options}")
    @options[:message_handler_block] = message_handler_block if message_handler_block
    connection.run
  end

  def stop
    @handler.stop
  end

  private

  def connection
    unless @connection
      @handler = ManageIQ::Providers::Nuage::NetworkManager::EventCatcher::MessagingHandler.new(@options)
      @connection = Qpid::Proton::Reactor::Container.new(@handler)
    end
    @connection
  end
end
