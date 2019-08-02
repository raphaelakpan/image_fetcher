require 'down'
require_relative './logger.rb'

class DownloadImage
  attr_reader :error

  DESTINATION = './downloads'
  MAX_SIZE = 5 * 1024 * 1024 # 5 MB

  def initialize(url)
    @url = url
    @error = nil
  end

  def perform
    log_start
    return unless valid_image_url?
    download
    return unless @error.nil?
    save_file
    log_end
  end

  private

  def log_start
    Logger.log "START downloading #{@url}"
  end

  def log_end
    Logger.success "FINISHED \n\n"
  end

  def download
    @temp_file = Down.download(@url, max_size: MAX_SIZE)
  rescue => e
    handle_error(e)
  end

  def save_file
    Dir.mkdir(DESTINATION) unless Dir.exist?(DESTINATION)
    destination_path = "#{DESTINATION}/#{@temp_file.original_filename}"
    FileUtils.mv(@temp_file.path, destination_path)
  end

  def handle_error(e)
    @error = case e
             when Down::InvalidUrl then
               "Invalid Image URL"
             when Down::TooLarge then
               "File is bigger than #{MAX_SIZE} MB"
             else
               "Unable to download Image"
             end
    Logger.error "#{@error}\n\n"
  end

  def valid_image_url?
    image_url_pattern = /(http(s?):)([\/|.|\w|\s|-])*\.(?:jpg|gif|png)/
    is_valid = Regexp.new(image_url_pattern).match?(@url)
    return true if is_valid

    @error = "Invalid image URL"
    Logger.error "#{@error}\n\n"
  end
end
