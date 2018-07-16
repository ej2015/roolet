require "spec_helper"

describe Roolet::Excelx::Sheet do
  let(:xlsx) { Roolet.new "#{RSPEC_ROOT}/fixtures/files/test.xlsx" }
	let(:sheet) { xlsx.default_sheet }
	let(:cells) { [ %w(name price amount), %w(a 1 20), %w(b 2 30) ] }


	describe '#name' do
    it 'returns the name of the sheet' do
			expect(sheet.name).to eq 'coffee'
		end
	end

	describe "#cells" do
    it 'returns cells as nested array of rows' do
      expect(sheet.cells.class). to eq Array 
		end
	end

	describe '#[]' do
		it 'returns the cell given the coordinate' do
			expect(sheet[1][1].value).to eq 1 
		end

		it 'returns the row given only the row coordinate' do
			expect(sheet[2].count).to eq 3
			expect(sheet[2][0].value).to eq 'b'
		end

		it 'returns an array of the cells with a range selector' do
			cells = sheet[1..2]
			expect(cells.length).to eq 2
			expect(cells[0][1].value).to eq 1
		end

	end

end
