require_relative '../file_manager'

describe FileManager do
  let(:file_manager) { FileManager.new('spec/postfix_test.log') }

  it '#initialize assign value to @filename' do
    expect(file_manager.filename).to eq 'postfix_test.log'
  end

  it '#initialize assign value to @lines_in_part_file' do
    expect(FileManager.new('postfix_test.log', 999).lines_in_part_file).to eq 999
  end

  it '#initialize assign value to @dir_path' do
    expect(file_manager.dir_path).to eq './splitted_postfix_test'
  end

  it '#initialize assign value to @next_file_index' do
    expect(file_manager.next_file_index).to eq 0
  end

  it '#initialize assign value to @splitted_files_names' do
    expect(file_manager.splitted_files_names).to eq []
  end

  it '#initialize @lines has default value' do
    expect(file_manager.lines_in_part_file).to eq 1000
  end

  it 'cretes directory for part files' do
    file_manager.process_file

    expect(Dir.exist?(file_manager.dir_path)).to be_truthy
  end

  it '#process_file removes directory with previous result for this filename' do
    file_manager = FileManager.new('spec/postfix_test_2.log')
    dir_path = 'splitted_postfix_test_2'
    system "mkdir #{dir_path}"
    system "touch #{dir_path + '/postfix_test_5678.txt'}"
    file_manager.process_file

    exist = File.exist?('splitted_postfix_test_2/postfix_test_5678.txt')
    system "rm -R #{dir_path}"
    expect(exist).to be_falsey
  end

  it '#make_directory creates proper directory' do
    file_manager.process_file

    expect(Dir.exist?('splitted_postfix_test')).to be_truthy
  end

  it '#get_next_filename return filenames with correct order' do
    file_manager.process_file
    expect(file_manager.get_next_filename).to eq './splitted_postfix_test/postfix_test_part_1.txt'
    expect(file_manager.get_next_filename).to eq './splitted_postfix_test/postfix_test_part_2.txt'
    expect(file_manager.get_next_filename).to eq './splitted_postfix_test/postfix_test_part_3.txt'
    expect(file_manager.get_next_filename).to eq './splitted_postfix_test/postfix_test_part_4.txt'
  end

  it '#get_next_filename increase @next_file_index by 1' do
    file_manager.process_file

    file_manager.get_next_filename
    expect(file_manager.next_file_index).to eq 1
    file_manager.get_next_filename
    expect(file_manager.next_file_index).to eq 2
  end
end
