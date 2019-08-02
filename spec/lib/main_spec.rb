require "spec_helper"
require_relative "../../lib/main.rb"
require_relative "../../lib/logger.rb"
require_relative "../../lib/process_file.rb"

RSpec.describe Main do
  let(:main) { Main.new }

  describe "#run" do

    before do
      allow(Logger).to receive(:log)
    end

    context "when file_path argument is nil" do
      it "logs relative path error message" do
        expect(ARGV).to receive(:first)
        expect(Logger).to receive(:warn)
          .with("Please provide a relative path (from this project folder) to your file")
        expect(ProcessFile).not_to receive(:new)

        main.run
      end
    end

    context "when file_path argument does not end in ".txt"" do
      it "logs a text file extension error message" do
        expect(ARGV).to receive(:first) { "../file.csv" }
        expect(Logger).to receive(:warn).with("Please provide a text file (.txt extension)")
        expect(ProcessFile).not_to receive(:new)

        main.run
      end
    end

    context "when file_path argument ends in ".txt"" do
      let(:file_path) { "../file.txt" }
      let(:process_file) { instance_double("ProcessFile", perform: nil) }

      it "calls ProcessFile with the absolute file path" do
        expect(ARGV).to receive(:first) { file_path }
        expect(ProcessFile).to receive(:new)
          .with(file_path) { process_file }

        main.run
      end
    end
  end
end
