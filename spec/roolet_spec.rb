require "spec_helper"

describe Roolet do
  let(:xlsx) { Roolet::Excelx.new "#{RSPEC_ROOT}/fixtures/files/test.xlsx" }

  it "has a version number" do
    expect(Roolet::VERSION).not_to be nil
  end

  describe '#new' do
    it 'returns a Roolet::Excelx object' do
      expect(xlsx.class).to eq Roolet::Excelx
		end
	end

	describe '#sheets' do
    it 'returns an array of Roolet::Excelx::Sheet object' do
			expect(xlsx.sheets.class).to eq Array
			expect(xlsx.sheets.first.class).to eq Roolet::Excelx::Sheet
		end
	end

	  describe '#sheet_names' do
    it 'returns an array of sheet names' do
      expect(xlsx.sheet_names).to contain_exactly 'coffee', 'tea'
		end
	end


	describe '#default_sheet' do
		it 'returns the first sheet as Roolet::Excelx::Sheet object' do
      expect(xlsx.default_sheet).to eq xlsx.sheets.first
		end
	end
end
