# frozen_string_literal: true

# Ruby 4.0 removed the deprecated `CGI.parse`, but VCR 6.1.0 still uses it as
# its default query parser when it is loaded. Provide an equivalent
# implementation so that `require 'vcr'` keeps working.
#
# This file must be required before Bundler.require loads the vcr gem.
require 'cgi'

unless CGI.respond_to?(:parse)
  def CGI.parse(query_string)
    pairs = {}
    query_string.to_s.split('&').each do |pair|
      key, value = pair.split('=', 2)
      next if key.nil? || key.empty? # rubocop:disable Rails/Blank

      (pairs[unescape(key)] ||= []) << unescape(value.to_s)
    end
    pairs
  end
end
