module ManageIQ::Providers::Nuage::NetworkManager::EventParser
  def self.event_to_hash(event, ems_id)
    {
      :source     => "Nuage",
      :event_type => "#{event['entityType']}_#{event['type'].downcase}",
      :timestamp  => DateTime.strptime((event["eventReceivedTime"]/1000).to_s, '%s').to_s,
      :message    => event.to_hash,
      :vm_ems_ref => nil,
      :full_data  => event,
      :ems_id     => ems_id
    }
  end
end
