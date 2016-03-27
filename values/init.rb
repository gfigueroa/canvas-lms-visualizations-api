Dir.glob('values/**/*.rb').each do |file|
  require_relative "../#{file}" unless "#{file}" == 'values/init.rb'
end
