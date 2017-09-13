require 'qpid_proton'

class ManageIQ::Providers::Nuage::NetworkManager::EventCatcher::MessagingHandler < Qpid::Proton::Handler::MessagingHandler
  def initialize(options = {})
    super()
    @options = options

    @url = @options.delete(:url)
    @topic = @options.delete(:topic)
    @test_connection = @options.delete(:test_connection)
    @message_handler_block = @options.delete(:message_handler_block)
  end

  def on_start(event)
    conn = event.container.connect(@url, @options)
    event.container.create_receiver(conn, :source => @topic) unless @test_connection
  end

  def on_connection_opened(event)
    # In case connection test was requested, close the connection immediately.
    event.container.stop if @test_connection
  end

  def on_connection_error(event)
    raise MiqException::MiqInvalidCredentialsError.new "Connection failed due to bad username or password"
  end

  def on_transport_error(event)
    raise MiqException::MiqHostError.new "Transport error"
  end

  def on_message(event)
    @message_handler_block.call(JSON.parse(event.message.body)) if @message_handler_block
  end
end
