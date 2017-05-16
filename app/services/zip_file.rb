module ZipFile
  require 'zip'
  extend self

  def temp_zip(temp_file, files_hash)
    Zip::OutputStream.open(temp_file)
    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
      files_hash.each_with_index do |f, idx|
        begin
          puts "start loading \#(#{idx}) #{f[:url]}"
          tmp_img = open(f[:url])
          zip.add(f[:name], tmp_img)
        rescue
          puts "error while add file to zip"
        end
        # tmp_img.delete
      end
    end
    # File.read(temp_file.path)
  end
end