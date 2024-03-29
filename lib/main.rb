
require_relative "./process_file.rb"
require_relative "./logger.rb"

class Main
  def run
    welcome
    get_file
  end

  private

  def get_file
    @file_path = ARGV.first # first argument from the command line
    return unless valid_input?
    process_file
  end

  def valid_input?
    if @file_path.nil?
      Logger.warn("Please provide a relative path (from this project folder) to your file")
      return false
    elsif (@file_path =~ /.txt/).nil?
      Logger.warn("Please provide a text file (.txt extension)")
      return false
    end
    true
  end


  def process_file
    ProcessFile.new(@file_path).perform
  end

  def welcome
    Logger.log(
      <<-GREET
        ::                                                      ::
        :: ::                                                :: ::
        Welcome to the Image Fetcher App 🤠
        This script will download images from URLs in your
        provided text file and store on your local disk directory
        :: ::                                                :: ::
        ::                                                      ::

      GREET
    )
  end
end
