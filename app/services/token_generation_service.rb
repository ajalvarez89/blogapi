module TokenGenerationService
  class Internal
    def self.generate
      SecureRandom.hex
    end
  end
end