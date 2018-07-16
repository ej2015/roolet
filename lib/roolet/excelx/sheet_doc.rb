module Roolet
	class Excelx
		class SheetDoc < Roo::Excelx::SheetDoc

      def create_cell_from_value(value_type, cell, formula, format, style, hyperlink, base_date, coordinate)
        # NOTE: format.to_s can replace excelx_type as an argument for
        #       Cell::Time, Cell::DateTime, Cell::Date or Cell::Number, but
        #       it will break some brittle tests.
        excelx_type = [:numeric_or_formula, format.to_s]
        # NOTE: There are only a few situations where value != cell.content
        #       1. when a sharedString is used. value = sharedString;
        #          cell.content = id of sharedString
        #       2. boolean cells: value = 'TRUE' | 'FALSE'; cell.content = '0' | '1';
        #          But a boolean cell should use TRUE|FALSE as the formatted value
        #          and use a Boolean for it's value. Using a Boolean value breaks
        #          Roo::Base#to_csv.
        #       3. formula
        case value_type
        when :shared
          value = shared_strings.use_html?(cell.content.to_i) ? shared_strings.to_html[cell.content.to_i] : shared_strings[cell.content.to_i]
          Excelx::Cell.create_cell(:string, value, formula, style, hyperlink, coordinate)
        when :boolean, :string
          value = cell.content
          Excelx::Cell.create_cell(value_type, value, formula, style, hyperlink, coordinate)
        when :time, :datetime
          cell_content = cell.content.to_f
          # NOTE: A date will be a whole number. A time will have be > 1. And
          #      in general, a datetime will have decimals. But if the cell is
          #      using a custom format, it's possible to be interpreted incorrectly.
          #      cell_content.to_i == cell_content && standard_style?=> :date
          #
          #      Should check to see if the format is standard or not. If it's a
          #      standard format, than it's a date, otherwise, it is a datetime.
          #      @styles.standard_style?(style_id)
          #      STANDARD_STYLES.keys.include?(style_id.to_i)
          cell_type = if cell_content < 1.0
                        :time
                      elsif (cell_content - cell_content.floor).abs > 0.000001
                        :datetime
                      else
                        :date
                      end
          Excelx::Cell.create_cell(cell_type, cell.content, formula, excelx_type, style, hyperlink, base_date, coordinate)
        when :date
          Excelx::Cell.create_cell(value_type, cell.content, formula, excelx_type, style, hyperlink, base_date, coordinate)
        else
          Excelx::Cell.create_cell(:number, cell.content, formula, excelx_type, style, hyperlink, coordinate)
        end
      end

      def extract_cells(relationships)
        extracted_cells = []
				doc.xpath('/worksheet/sheetData/row/c').each do |cell_xml|
          key = ::Roo::Utils.ref_to_key(cell_xml['r'])
				  #[key, cell_from_xml(cell_xml, hyperlinks(relationships)[key])]
				  cell = cell_from_xml(cell_xml, hyperlinks(relationships)[key])

          extracted_cells[cell.coordinate.row-1] ||= []
					extracted_cells[cell.coordinate.row-1][cell.coordinate.column-1] = cell
        end

        #expand_merged_ranges(extracted_cells) if @options[:expand_merged_ranges]

        extracted_cells
      end
			
		end
	end
end
