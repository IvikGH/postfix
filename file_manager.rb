require 'byebug'

class FileManager
  attr_reader :filename, :dir_path, :splitted_files_names, :lines_in_part_file,
              :main_file, :only_name

  attr_accessor :next_file_index

  # LINES_IN_FILE = 1000

  def initialize(filename, lines_in_file=1000)
    # p ' '.rjust(8) + "initialize(filename)"
    @main_file = filename
    @filename = filename.split('/').last
    @lines_in_part_file = lines_in_file
    @dir_path = './splitted_' + File.basename(filename,
                                              File.extname(filename))
    @only_name = File.basename(filename, File.extname(filename))
    @next_file_index = 0
    @splitted_files_names = []
  end

  def process_file
    # p ' '.rjust(8) + "process_file"
    system "rm -R #{dir_path}" if splitted_files?
    make_directory(dir_path)
    split_main_file
  end

  def get_next_filename
    # p ' '.rjust(8) + "get_next_filename"
    @next_file_index += 1
    splitted_files_names[@next_file_index - 1]
  end

  private

  def split_main_file
    # p ' '.rjust(8) + "split_main_file"
    main_file = File.new(@main_file)
    counter = 0

    loop do
      counter += 1
      part_file = File.new(file_path(counter), "w")

      lines = gather_lines(main_file)
      part_file.write(lines.join)
      splitted_files_names << part_file.path
      part_file.close
      break unless lines.any?
    end
  end

  def gather_lines(main_file)
    lines = []
    while split_condition?(lines)
      line = main_file.gets
      lines << line
      break lines if line.nil?
    end
    lines
  end

  def file_path(counter)
    # p ' '.rjust(8) + "file_path(counter)"
    dir_path + '/' + only_name + "_part_#{counter}.txt"
  end

  def split_condition?(lines)
    # p ' '.rjust(8) + "split_condition?(lines)"
    lines.size < lines_in_part_file
  end

  def make_directory(dir_path)
    # p ' '.rjust(8) + "make_directory(dir_path)"
    Dir.mkdir(dir_path)
  end

  def splitted_files?
    # p ' '.rjust(8) + "splitted_files?"
    Dir.exist?(dir_path) && (Dir.entries(dir_path).size > 2)
  end
end
