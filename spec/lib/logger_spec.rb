require "spec_helper"
require_relative "../../lib/logger.rb"

RSpec.describe Logger do
  let(:message) { "hello" }

  describe "::success" do
    it "logs to standout output with check mark emoji" do
      expect(STDOUT).to receive(:puts).with("✅ ✅ --> #{message}")
      Logger.success(message)
    end
  end

  describe "::warn" do
    it "logs to standout output with warning emoji" do
      expect(STDOUT).to receive(:puts).with("⚠️ ⚠️ --> #{message}")
      Logger.warn(message)
    end
  end

  describe "::error" do
    it "logs to standout output alert emoji" do
      expect(STDOUT).to receive(:puts).with("🚨 🚨 --> #{message}")
      Logger.error(message)
    end
  end

  describe "::log" do
    it "logs to standout output with no formating" do
      expect(STDOUT).to receive(:puts).with(message)
      Logger.log(message)
    end
  end
end
