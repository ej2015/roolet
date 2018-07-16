require "spec_helper"

describe Roolet::Excelx::Cell do
  let(:xlsx) { Roolet.new "#{RSPEC_ROOT}/fixtures/files/test.xlsx" }
	let(:sheet) { xlsx.default_sheet }
	let(:cells) { sheet.cells }
  let(:cell) { sheet[1][2] }

  describe '#coordinates' do
    it 'returns the coordinates in [row, col]' do
      expect(cell.coordinates).to eq [1,2]
		end
	end	



end
