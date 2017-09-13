class ManageIQ::Providers::Nuage::NetworkManager < ManageIQ::Providers::NetworkManager
  include SupportsFeatureMixin
  require_nested :EventCatcher
  require_nested :EventParser
  require_nested :RefreshParser
  require_nested :RefreshWorker
  require_nested :Refresher
  require_nested :VsdClient
  supports :ems_network_new

  include Vmdb::Logging
  include ManageIQ::Providers::Nuage::ManagerMixin

  def self.ems_type
    @ems_type ||= "nuage_network".freeze
  end

  def self.description
    @description ||= "Nuage Network Manager".freeze
  end

  def supported_auth_types
    %w(default amqp)
  end

  def supports_authentication?(authtype)
   supported_auth_types.include?(authtype.to_s)
  end

  def self.event_monitor_class
    ManageIQ::Providers::Nuage::NetworkManager::EventCatcher
  end
end
