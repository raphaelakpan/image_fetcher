class Logger
  def self.success(message)
    puts "✅ ✅ --> #{message}"
  end

  def self.warn(message)
    puts "⚠️ ⚠️ --> #{message}"
  end

  def self.error(message)
    puts "🚨 🚨 --> #{message}"
  end

  def self.log(message)
    puts message
  end
end
