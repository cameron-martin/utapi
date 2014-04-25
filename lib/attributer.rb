class Attributer
  def self.new(*attributes)
    Module.new do

      define_singleton_method :included do |other|
        other.class_eval do
          attr_reader *attributes
        end
      end

      define_method :initialize do |data|
        attributes.each do |attribute|
          instance_variable_set("@#{attribute}", data[attribute])
        end
      end

    end
  end
end