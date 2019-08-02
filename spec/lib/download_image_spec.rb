require "spec_helper"
require "down"
require_relative "../../lib/download_image.rb"
require_relative "../../lib/logger.rb"

RSpec.describe DownloadImage do
  let(:url) { "https://somesite.com/wp-content/image.png" }

  describe "#perform" do
    let(:download_image) { DownloadImage.new(url) }

    before do
      # mocking it so it doesn't actually run
      allow(Logger).to receive(:log)
    end

    context "url is invalid image url" do
      let(:url) { "https://somesite.com/wp-content/image" }

      it "stores an invalid image url error message" do
        expect(Logger).to receive(:error)
        expect(download_image).not_to receive(:download)

        download_image.perform

        expect(download_image.error).to eq "Invalid image URL. Image must be JPG, GIF or PNG"
      end
    end

    context "when image size is bigger than 5MB" do
      it "stores an invalid file size error message" do
        expect(Down).to receive(:download).with(
          url, max_size: DownloadImage::MAX_SIZE
        ) { raise Down::TooLarge }

        expect(Logger).to receive(:error)

        download_image.perform

        expect(download_image.error).to eq "File is bigger than #{DownloadImage::MAX_SIZE} MB"
      end
    end

    context "when an exception is raised while downloading the image" do
      it "stores an error message" do
        expect(Down).to receive(:download).with(
          url, max_size: DownloadImage::MAX_SIZE
        ) { raise Down::ConnectionError }

        expect(Logger).to receive(:error)

        download_image.perform

        expect(download_image.error).to eq "Unable to download Image"
      end
    end

    context "when image is successfully downloaded" do
      let(:file_path) { "/var/origin" }
      let(:file_name) { "name.png" }
      let(:temp_file) do
        double("Tempfile", path: file_path, original_filename: file_name)
      end
      let(:destination_path) { "#{DownloadImage::DESTINATION}/#{temp_file.original_filename}" }

      context "and destination folder does not exist" do
        it "creates a new folder and saves the image" do
          expect(Down).to receive(:download).with(
            url, max_size: DownloadImage::MAX_SIZE
          ) { temp_file }

          expect(Dir).to receive(:exist?).with(DownloadImage::DESTINATION) { false }
          expect(Dir).to receive(:mkdir).with(DownloadImage::DESTINATION)

          expect(FileUtils).to receive(:mv).with(temp_file.path, destination_path)
          expect(Logger).to receive(:success)

          download_image.perform

          expect(download_image.error).to be_nil
        end
      end

      context "and destination folder exist" do
        it "does not create a new folder saves the image" do
          expect(Down).to receive(:download).with(
            url, max_size: DownloadImage::MAX_SIZE
          ) { temp_file }

          expect(Dir).to receive(:exist?).with(DownloadImage::DESTINATION) { true }
          expect(Dir).not_to receive(:mkdir).with(DownloadImage::DESTINATION)

          expect(FileUtils).to receive(:mv).with(temp_file.path, destination_path)
          expect(Logger).to receive(:success)

          download_image.perform

          expect(download_image.error).to be_nil
        end
      end
    end
  end
end
