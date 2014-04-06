require 'json'

# Загоняем весь JSON в хэш
list = JSON::parse(File.open("tooltips.json").read)

# Открываем файл на выходе
output = File.open("../../output/tooltips.xml", "w")

# Пишем копирайт Subset Games, не надо их обижать за такую крутую игру
output.puts "<!-- Copyright (c) 2012 by Subset Games. All rights reserved -->"

# Выписываем теги
list.each do |k, v|
  output.puts "<" + k + ">" + v + "</" + k + ">"
end

# Закрываем файл, ибо надо!
output.close
