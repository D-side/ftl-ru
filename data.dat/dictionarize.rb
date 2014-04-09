# Sweep translated file
total = 0
suspicious = []

#checklist = Dir.entries("./data.old.en")
checklist = ["events_ships.xml"]

checklist.each do |source_file|
  #source_file = "tooltips.xml"
  #Nonono, not this one anymore, we're going generic

  if [".", ".."].include?(source_file)
    next
  end

  ru = File.read("./xml.ru.utf8/" + source_file)

  tooltips_ru = ru.scan(/>([\%\_0-9\(\)\«А-ЯA-Z][\%\_\(\)0-9,ЁёA-Za-zА-Яа-я[[:space:]]\.\:\-\/\«\»\"\!\?\—\;\']+)\<\//).collect {|i| i[0] }

  # Sweep original file
  en = File.read("./data.old.en/" + source_file)

  tooltips_en = en.scan(/>([\%\_0-9\(\)\"\ A-Z][\%\_\(\)0-9A-Za-z\:[[:space:]]\,\'\.\-\/\"\!\?\;]+)\<\//).collect {|i| i[0] }

  en_ae = File.read("./data/" + source_file)

  if tooltips_ru.length != tooltips_en.length
    puts "Now processing file: " + source_file
    puts "Entries:\tRU: " + tooltips_ru.length.to_s + "\tEN: " + tooltips_en.length.to_s
    puts "[!] WARNING: unequal phrase banks' lengths, investigate it"
    puts ""
    suspicious << (source_file)
  end

  tooltips = {}
  0.upto(tooltips_ru.length - 1) { |i|
    tooltips[tooltips_en[i]] = tooltips_ru[i]
    if (checklist.length < 3)
      puts "#{i+1}/#{tooltips_ru.length - 1}"
      puts "ru: " + tooltips_ru[i]
      puts "en: " + tooltips_en[i]
      puts "Replacing..."
      $stdin.readchar
    end
    en_ae.gsub!(tooltips_en[i], tooltips_ru[i])
    # Used to be a pause
    }

  result = File.open("result/" + source_file, "wt")
  result.write(en_ae)
  result.close

  total += 1
end
puts "Total files processed: #{total}, #{suspicious.length} of them are suspicious and should be looked at:"
puts suspicious.join(" ")
