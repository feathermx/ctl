class Api::Km < Km
  
  scope :filter_base, ->{ select('kms.id, kms.name') }
  scope :api_base, ->{ select('kms.id, kms.shops_count, kms.public_meter_length, kms.dedicated_meter_length, kms.peak_deliveries, kms.peak_traffic, kms.peak_deliveries') }
  
end