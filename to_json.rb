require 'json'
require 'csv'

file_name= 'comunas.csv'

File.open("#{file_name}.json", "w") { |f| f.write(CSV.open(file_name, headers: true, header_converters: :symbol, converters: :all).to_a.map{|row| row.to_hash }.to_json) }

File.close
