module Csv2json

  def self.csv_to_json(path)
    file_name = File.basename(path, '.*')

    File.open("public/json/#{file_name}.json", "w") do |f|
      f.write(CSV.open(path, headers: true, header_converters: :symbol, converters: :all).to_a.map(&:to_hash).to_json)
      f.close
    end
  end

end
