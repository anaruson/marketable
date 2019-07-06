# frozen_string_literal: true
#
# Creates scheduled sidekiq jobs using pre-defined file path from constant DOMAINS_PATH
# DOMAINS_PATH => full path to domains file. Each domain must be separated by a newline character (\n)
#
require 'socket'

module Marketable
  class FileWorker

    include Sidekiq::Worker
    include Sidetiq::Schedulable

    sidekiq_options queue: :default, retry: true
    recurrence { daily }

    DOMAINS_PATH = '/Users/ahti/Downloads/domain-list-V1-21022019.txt'

    def perform
      #binding.pry
      domains = read_file(DOMAINS_PATH)

      domains.each do |domain|
        Rails.logger.info "Submit job for domain #{domain}"
        ::Marketable::WhoisWorker.perform_async(domain)
      end
    end

    private

    def read_file(file_path)
      data = Array.new

      ::File.read(file_path).each_line do |line|
        data.append(line.strip)
      rescue ArgumentError
        Rails.logger.warn "domain #{line} is malformed"
      end
      data
    end
  end
end
