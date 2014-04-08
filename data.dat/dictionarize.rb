# Sweep translated file
Dir.entries("./data.old.en").each do |source_file|
	#source_file = "tooltips.xml"
	#Nonono, not this one anymore, we're going generic
	
	if [".", ".."].include?(source_file)
	  next
	end
    puts "Now processing file: " + source_file

	ru = File.read("./xml.ru.utf8/" + source_file)

	tooltips_ru = ru.scan(/>([\«А-ЯA-Z][0-9,ёA-ZА-Яа-я[[:space:]]\.\:\-\/\«\»\"\!\?\—\;\']+)\<\//).collect {|i| i[0] }

	# Sweep original file
	en = File.read("./data.old.en/" + source_file)

	tooltips_en = en.scan(/>([\"\ A-Z][0-9A-Za-z\:[[:space:]]\,\'\.\-\/\"\!\?\;]+)\<\//).collect {|i| i[0] }

	en_ae = File.read("./data/" + source_file)

	puts "\tRU: " + tooltips_ru.length.to_s + "\tEN: " + tooltips_en.length.to_s
	puts "[!] WARNING: unequal phrase banks' lengths, investigate it" unless tooltips_ru.length == tooltips_en.length
	tooltips = {}
	0.upto(tooltips_ru.length - 1) { |i|
	  tooltips[tooltips_en[i]] = tooltips_ru[i]
	  #puts "ru: " + tooltips_ru[i]
	  #puts "en: " + tooltips_en[i]

	  #puts "Replacing..."
	  en_ae.gsub!(tooltips_en[i], tooltips_ru[i])
	  # Used to be a pause
	  #$stdin.readchar
	}

	result = File.open("result/" + source_file, "wt")
	result.write(en_ae)
	result.close
	puts ""
end
