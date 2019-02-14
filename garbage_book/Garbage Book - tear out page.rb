#!/usr/bin/env ruby
# Exchange the slug and timestamp of a Garbage Book page, effectively "tearing it out."

if /^(\d{4}\.\d{2}\.\d{2} \(\d{4}\)) (.*).txt$/.match(ENV['BB_DOC_NAME'])
  timestamp = $1
  slug = $2

  new_name = File.join(File.dirname(ENV['BB_DOC_PATH']), "#{slug} #{timestamp}.txt")
  File.rename(ENV['BB_DOC_PATH'], new_name)
end
