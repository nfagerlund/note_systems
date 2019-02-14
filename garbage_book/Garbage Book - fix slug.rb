#!/usr/bin/env ruby
# Tidy up the slug on Garbage Book pages, and leave other filenames alone

ARGF.set_encoding('utf-8')
annoying_characters = %r{[\\/:\*\?"<>\|#%$;?\n\r]}
slug_length = 25

if /^(\d{4}\.\d{2}\.\d{2} \(\d{4}\)) .*.txt$/.match(ENV['BB_DOC_NAME'])
  timestamp = $1
  slug = ARGF.gets.chomp[0..slug_length].gsub(annoying_characters, '_').sub(/[ _\.]+$/, '')
  new_name = File.join(File.dirname(ENV['BB_DOC_PATH']), "#{timestamp} #{slug}.txt")
  File.rename(ENV['BB_DOC_PATH'], new_name)
end
