class ManageIQ::Providers::Nuage::NetworkManager::EventCatcher::Runner < ManageIQ::Providers::BaseManager::EventCatcher::Runner
  def event_monitor_handle
    unless @event_monitor_handle
      options = @ems.event_monitor_options
      # Only the events topic is relevant
      options[:topic] = 'topic://topic/CNAMessages'
      @event_monitor_handle = ManageIQ::Providers::Nuage::NetworkManager::EventCatcher::Stream.new(options)
    end
    @event_monitor_handle
  end

  def reset_event_monitor_handle
    @event_monitor_handle = nil
  end

  # Start monitoring for events. This method blocks forever until stop_event_monitor is called.
  def monitor_events
    event_monitor_handle.start do |event|
      event_monitor_running
      @queue.enq event
    end
  ensure
    stop_event_monitor
  end

  def stop_event_monitor
    @event_monitor_handle.try!(:stop)
  ensure
    reset_event_monitor_handle
  end

  def queue_event(event)
    event_hash = ManageIQ::Providers::Nuage::NetworkManager::EventParser.event_to_hash(event, @cfg[:ems_id])
    EmsEvent.add_queue('add', @cfg[:ems_id], event_hash)
  end

  def topic_names
    "topic://topic/CNAMessages"
  end
end
