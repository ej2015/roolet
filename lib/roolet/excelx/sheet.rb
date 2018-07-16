module Roolet
	class Excelx
		class Sheet < Roo::Excelx::Sheet
			attr_reader :name

			def initialize(name, shared, sheet_index, options = {})
        super
				@sheet = SheetDoc.new(sheet_files[sheet_index], @rels, shared, options)
			end

			def [](index)
        cells[index]
			end

		end
	end
end
