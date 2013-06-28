module Weekable
  
  extend ActiveSupport::Concern
  
  included do
    
    module Days
      
      Sunday = 1
      Monday = 2
      Tuesday = 4
      Wednesday = 8
      Thursday = 16
      Friday = 32
      Saturday = 64
      
      List = {
        Sunday => {
          name: I18n.t('app.concern.weekable.days.sunday'),
          key: 'D'
        },
        Monday => {
          name: I18n.t('app.concern.weekable.days.monday'),
          key: 'M'
        },
        Tuesday => {
          name: I18n.t('app.concern.weekable.days.tuesday'),
          key: 'T'
        },
        Wednesday => {
          name: I18n.t('app.concern.weekable.days.wednesday'),
          key: 'W'
        },
        Thursday => {
          name: I18n.t('app.concern.weekable.days.thursday'),
          key: 'R'
        },
        Friday => {
          name: I18n.t('app.concern.weekable.days.friday'),
          key: 'F'
        },
        Saturday => {
          name: I18n.t('app.concern.weekable.days.saturday'),
          key: 'S'
        }
      }
      
      def self.list_with_keys
        @@list_with_keys ||= ->{
          list = {}
          List.each do |key, data|
            list[data[:key]] = key
          end
          list
        }.call
      end
      
    end
    
    def week_val(val, sep = '-')
      week = 0
      unless val.blank?
        days = val.split(sep)
        days.each do |el|
          day = Days.list_with_keys[el.upcase]
          week |= day unless day.nil?
        end
      end
      week
    end
    
  end
  
  
end