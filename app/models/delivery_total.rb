class DeliveryTotal < ActiveRecord::FmxBase
  
  module Day
    
    Sunday = 0
    Monday = 1
    Tuesday = 2
    Wednesday = 3
    Thursday = 4
    Friday = 5
    Saturday = 6
    
    List = {
      Sunday => {
        name: I18n.t('app.model.delivery_total.day.sunday'),
        namespace: 'sun'
      },
      Monday => {
        name: I18n.t('app.model.delivery_total.day.monday'),
        namespace: 'mon'
      },
      Tuesday => {
        name: I18n.t('app.model.delivery_total.day.tuesday'),
        namespace: 'tue'
      },
      Wednesday => {
        name: I18n.t('app.model.delivery_total.day.wednesday'),
        namespace: 'wed'
      },
      Thursday => {
        name: I18n.t('app.model.delivery_total.day.thursday'),
        namespace: 'thu'
      },
      Friday => {
        name: I18n.t('app.model.delivery_total.day.friday'),
        namespace: 'fri'
      },
      Saturday => {
        name: I18n.t('app.model.delivery_total.day.saturday'),
        namespace: 'sat'
      }
    }
    
    def self.keys
      @@keys ||= List.keys
    end
    
  end
  
  scope :base, ->{ select('delivery_totals.id, delivery_totals.km_id, delivery_totals.hour, delivery_totals.total_sun, delivery_totals.total_mon, delivery_totals.total_tue, delivery_totals.total_wed, delivery_totals.total_thu, delivery_totals.total_fri, delivery_totals.total_sat') }
  scope :base_count, ->{ select('COUNT(delivery_totals.id) as num') }
  scope :filter_by_id, ->(id){ where(id: id) }
  scope :filter_by_km, ->(km_id){ where(km_id: km_id) }
  scope :ascending, ->{ order('delivery_totals.hour ASC') }
  
  attr_protected :km_id, :hour, :total_sun, :total_mon, :total_tue, :total_wed, :total_thu, :total_fri, :total_sat
  
  validates :km_id, :hour, :total_sun, :total_mon, :total_tue, :total_wed, :total_thu, :total_fri, :total_sat, presence: true
  validates :hour, uniqueness: { scope: :km_id }
  
  def self.generate(hour, km)
    el = self.new
    el.km_id = km.id
    el.hour = "#{hour}:00:00 +00:00"
    max = 0
    Day::List.each do |key, day|
      field_name = "total_#{day[:namespace]}="
      count = Delivery.count_for_day_hour(key, hour, km)
      max = count if count > max
      el.send(field_name, count)
    end
    { el: el, max: max }
  end
  
  def hour_i
    @hour_i ||= self.hour.hour
  end
  
  
end