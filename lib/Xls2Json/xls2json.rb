module Xls2json

  def self.xls_to_json(path)
    excel_path = path
    json_path = 'public/json/' + File.basename(path, '.*') + '.json'

    sheet_number = 1 # sheet number start from 0
    header_row_number = 1 # row number of the header row which contains column names.
                          # row before this number get ignored.
                          # row numbers start from 1 based on Excel conventions.
    Xlsx2json::Transformer.execute excel_path, sheet_number, json_path, header_row_number: header_row_number
  end

end