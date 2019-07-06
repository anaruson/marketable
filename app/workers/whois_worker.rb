# frozen_string_literal: true
#
require 'whois-parser'

module Marketable
  class WhoisWorker

    RECENTLY_PROCESSED = 14

    include Sidekiq::Worker

    sidekiq_options queue: :default, retry: true

    def perform(domain)
      return if recently_processed?(domain)

      record = Whois.whois(domain)
      parser = record.parser

      Domain.where(name: domain).first_or_create!(
        name: domain,
        expiration: parser.expires_on,
        available: parser.available?,
        registered: parser.registered?,
        registered_at: parser.created_on,
        processed_at: Time.now,
        whois_data: record.to_s
      )
    end

    private

    def recently_processed?(domain)
      domain = Domain.find_by(name: domain)
      return false unless domain

      domain.processed_at > RECENTLY_PROCESSED.days.ago
    end

  end
end
