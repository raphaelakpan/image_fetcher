require_relative './download_image.rb'
require_relative './logger.rb'

class ProcessFile
  def initialize(file_path)
    @file_path = file_path
    @errors = 0
    @downloaded = 0
  end

  def perform
    File.foreach(@file_path) do |url|
      download_file(url)
    end
    display_results
  rescue Errno::ENOENT => e
    Logger.error 'Unable to read file. Please provide a relative path to an existing text file'
  end

  def download_file(url)
    download = DownloadImage.new(url)
    download.perform
    if download.error.nil?
      @downloaded += 1
    else
      @errors += 1
    end
  end

  def display_results
    Logger.log(
      <<-MSG

      📣 📣 📣 📣 D•O•N•E 📣 📣 📣 📣
      ✅ DOWNLOADED: #{@downloaded} images
      🚨 ERRORS: #{@errors}

      FOLDER -> #{DownloadImage::DESTINATION}

      MSG
    )
  end
end
