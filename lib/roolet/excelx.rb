module Roolet
  class Excelx < Roo::Excelx
		attr_reader :sheets, :sheet_names
 
	  require 'roolet/excelx/sheet'
	  require 'roolet/excelx/sheet_doc'
	  require 'roolet/excelx/cell'

		def initialize(filename_or_stream, options = {})
      packed = options[:packed]
      file_warning = options.fetch(:file_warning, :error)
      cell_max = options.delete(:cell_max)
      sheet_options = {}
      sheet_options[:expand_merged_ranges] = (options[:expand_merged_ranges] || false)
      sheet_options[:no_hyperlinks] = (options[:no_hyperlinks] || false)
      #shared_options = {}
        
      #shared_options[:disable_html_wrapper] = (options[:disable_html_wrapper] || false)
      unless is_stream?(filename_or_stream)
        file_type_check(filename_or_stream, %w[.xlsx .xlsm], 'an Excel 2007', file_warning, packed)
        basename = find_basename(filename_or_stream)
      end

      # NOTE: Create temp directory and allow Ruby to cleanup the temp directory
      #       when the object is garbage collected. Initially, the finalizer was
      #       created in the Roo::Tempdir module, but that led to a segfault
      #       when testing in Ruby 2.4.0.
      @tmpdir = self.class.make_tempdir(self, basename, options[:tmpdir_root])
      ObjectSpace.define_finalizer(self, self.class.finalize(object_id))

      #@shared = Shared.new(@tmpdir, shared_options)
      @shared = Shared.new(@tmpdir)
      @filename = local_filename(filename_or_stream, @tmpdir, packed)
      process_zipfile(@filename || filename_or_stream)

      @sheet_names = workbook.sheets.map do |sheet|
        unless options[:only_visible_sheets] && sheet['state'] == 'hidden'
          sheet['name']
        end
      end.compact
      @sheets = []
      @sheets_by_name = Hash[@sheet_names.map.with_index do |sheet_name, n|
        @sheets[n] = Sheet.new(sheet_name, @shared, n, sheet_options)
        [sheet_name, @sheets[n]]
      end]

      if cell_max
        cell_count = ::Roo::Utils.num_cells_in_range(sheet_for(options.delete(:sheet)).dimensions)
        raise ExceedsMaxError.new("Excel file exceeds cell maximum: #{cell_count} > #{cell_max}") if cell_count > cell_max
      end

    rescue
      self.class.finalize_tempdirs(object_id)
      raise
		end




  end
end
