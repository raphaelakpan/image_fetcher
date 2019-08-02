require "spec_helper"
require_relative "../lib/process_file.rb"
require_relative "../lib/logger.rb"
require_relative "../lib/download_image.rb"

RSpec.describe ProcessFile do
  let(:file_path) { "/path/to/file.txt" }
  let(:process_file) { ProcessFile.new(file_path) }
  let(:file_contents) { ["url.png", "url-2.jpg"] }

  describe "#perform" do

    before do
      allow(File).to receive(:foreach)
      allow(Logger).to receive(:log)
    end

    context "when file exists" do
      let(:download_image) do
        instance_double("DownloadImage", perform: nil, error: nil)
      end

      before do
        allow(File).to receive(:foreach)
          .with(file_path)
          .and_yield(file_contents[0])
          .and_yield(file_contents[1])
      end

      it "calls DownloadImage with each line in file" do
        expect(DownloadImage).to receive(:new)
          .with(file_contents[0]) { download_image }
        expect(DownloadImage).to receive(:new)
          .with(file_contents[1]) { download_image }

        process_file.perform
      end

      it "tracks error and downloaded counts" do
        error_download = instance_double("DownloadImage", perform: nil, error: "Error")

        expect(DownloadImage).to receive(:new)
          .with(file_contents[0]) { download_image }
        expect(DownloadImage).to receive(:new)
          .with(file_contents[1]) { error_download }

        process_file.perform

        expect(process_file.errors).to eq 1
        expect(process_file.downloaded).to eq 1
      end
    end

    context "when file does not exists" do
      it "logs an error" do
        expect(File).to receive(:foreach) { raise Errno::ENOENT }
        expect(Logger).to receive(:error)
          .with("Unable to read file. Please provide a relative path to an existing text file")

        process_file.perform
      end
    end
  end
end
