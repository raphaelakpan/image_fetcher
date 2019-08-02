require_relative './download_image.rb'
require_relative './logger.rb'

class ProcessFile
  attr_reader :errors, :downloaded

  def initialize(file_path)
    @file_path = file_path
    @errors = 0
    @downloaded = 0
  end

  def perform
    log_file
    File.foreach(@file_path) do |url|
      download_file(url)
    end
    log_results
  rescue Errno::ENOENT => e
    Logger.error 'Unable to read file. Please provide a relative path to an existing text file'
  end

  private

  def download_file(url)
    download = DownloadImage.new(url)
    download.perform
    if download.error.nil?
      @downloaded += 1
    else
      @errors += 1
    end
  end

  def log_file
    Logger.log("PROCESSING: --> #{@file_path}\n\n")
  end

  def log_results
    Logger.log(
      <<-MSG

      📣 📣 📣 📣 D•O•N•E 📣 📣 📣 📣
      ✅ DOWNLOADED: #{@downloaded} images
      🚨 ERRORS: #{@errors}

      FOLDER --> #{DownloadImage::DESTINATION}

      MSG
    )
  end
end
