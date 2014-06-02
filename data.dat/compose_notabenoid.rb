#path_list = ["data/tooltips.xml"]
list_file = File.open("rem.flst")
path_list = []
path_list << list_file.collect { |line|
	[File.join("result", line.chomp), File.join("data", line.chomp)]
}
path_list << File.join("data", "misc.xml")
#path_list =	Dir.entries("data").collect do |e|
#	f = File.join("data", e)
#	f if !File.directory?(f)
#end
puts path_list.inspect
path_list.compact!
puts path_list.inspect
path_list.flatten! # That's an order!
blacklist = %w(autoReward fleet clone)
# Общий чёрный список тегов, не нуждающихся в переводе
#blacklist = %w(img ship x y rarity bp cost startPower maxPower level type locked sp fireChance breachChance cooldown power image damage shots sound weaponArt speed ion droneSlots weaponSlots number direction shieldImage cloakImage boardingAI value tip iconImage weaponBlueprint droneImage dodge missiles persDamage sysDamage explosion stunChance r g b length target stackable multiDifficulty autoReward name hullBust radius spin drone_targetable projectile amount count chargeLevels stun)

#Белые списки на каждый файл - выше по приоритету, чем чёрный список
whitelists = Hash.new([])
#whitelists["data/achievements.xml"] = %w(name)

path_list.each do |path|
	output_path = "lists/#{path}.list";
	input = File.open(path, "rt");
	output = File.open(output_path, "wt")

	phrase_list = input.collect do |line|
		matches = /<([A-Za-z_]+).*>([^<]+)<\/\1>/.match(line)
		if matches and
		(!blacklist.include?(matches[1]) or whitelists[path].include?(matches[1])) then
			"#{matches[2]}\n\n"
		else
			nil
		end
	end
	phrase_list.compact.uniq.each do |phrase|
		output.print phrase
	end
	input.close
	output.close
	File.delete(output_path) if File.size(output_path) == 0	
end

