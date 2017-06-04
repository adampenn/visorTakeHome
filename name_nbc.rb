#!/usr/bin/ruby

Dir.chdir("/home/adam/visorTakeHome")

# Read in description and split it into words
lastNamesDic = File.read('name_learn_files/last_names.txt').split("\n")
englishWordsDic = File.read('name_learn_files/last_names.txt').split("\n")

lastNameNumDesc = lastNamesDic.size
englishWordsNumDesc = englishWordsDic.size

lastNamesDic = File.read('w2_learn_files/W2_Learn_File.txt').split(/\W+/)
englishWordsDic = File.read('1099_learn_files/1099_Learn_File.txt').split(/\W+/)

# Read in description from user
userDesc = (ARGV[0]).split(/\W+/)
userDesc = userDesc.uniq

# init laplace smoothing value and number of classes
k = 1
cl = 1

# Count the occurances of each words
lastNameCount = Array.new
tmpIndiv = Array.new
# init lastNameCount
i = 0
lastNamesDic.each do |x|
  if tmpIndiv.index(x)
    j = tmpIndiv.index(x)
    lastNameCount[j] = lastNameCount[j]+1
  else
    lastNameCount[i] = 1;
    tmpIndiv.push(x)
    i = i + 1
  end
end
lastNamesDic = lastNamesDic.uniq

# init englishWordsCount
englishWordsCount = Array.new
tmpIndiv = Array.new
i = 0
englishWordsDic.each do |x|
  if tmpIndiv.index(x)
    j = tmpIndiv.index(x)
    englishWordsCount[j] = englishWordsCount[j]+1
  else
    englishWordsCount[i] = 1;
    tmpIndiv.push(x)
    i = i + 1
  end
end
englishWordsDic = englishWordsDic.uniq

dictionary = lastNamesDic+englishWordsDic
dictionary = dictionary.uniq
dictionarySize = dictionary.size

probLastName = (lastNameNumDesc+k).to_f/((lastNameNumDesc+englishWordsNumDesc)+(k*cl)).to_f
probEnglishWords = (englishWordsNumDesc+k).to_f/((lastNameNumDesc+englishWordsNumDesc)+(k*cl)).to_f

# Calculate P(userWord | w2)
# puts "\nCalculate P(userWord | w2)", "-"*50
userProbLastName = Array.new
userDesc.each do |x|
  if(lastNamesDic.index(x))
    tmp = (lastNameCount[lastNamesDic.index(x)]+k).to_f/(lastNamesDic.size+(k*dictionarySize)).to_f
  else
    tmp = k.to_f/(lastNamesDic.size+(k*dictionarySize)).to_f
  end
  userProbLastName.push(tmp)
  # puts "P(#{x}|w2) = #{tmp}"
end

# Calculate P(userWord | f1099)
# puts "\nCalculate P(userWord | f1099)", "-"*50
userProbEnglishWords = Array.new
userDesc.each do |x|
  if(englishWordsDic.index(x))
    tmp = (englishWordsCount[englishWordsDic.index(x)]+k).to_f/(englishWordsDic.size+(k*dictionarySize)).to_f
  else
    tmp = k.to_f/(englishWordsDic.size+(k*dictionarySize)).to_f
  end
  userProbEnglishWords.push(tmp)
  # puts "P(#{x}|f1099) = #{tmp}"
end

# Calculate P(userDesc | w2)
probDescLastName = 0
userProbLastName.each do |x|
  if probDescLastName == 0
    probDescLastName = x
  else
    probDescLastName = probDescLastName * x
  end
end

# Calculate P(userDesc | f1099)
probDescEnglishWords = 0
userProbEnglishWords.each do |x|
  if probDescEnglishWords == 0
    probDescEnglishWords = x
  else
    probDescEnglishWords = probDescEnglishWords * x
  end
end

# puts "probDescEnglishWords " , probDescEnglishWords, "  probDescLastName ", probDescLastName

# Calculate P(w2 | userDesc)
probLastNameDesc = (probDescLastName*probLastName)/((probDescLastName*probLastName)+(probDescEnglishWords*probEnglishWords))

# Calculate P(f1099 | userDesc)
probEnglishWordsDesc = (probDescEnglishWords*probEnglishWords)/((probDescLastName*probLastName)+(probDescEnglishWords*probEnglishWords))

puts "P(english | userDesc): ", probEnglishWordsDesc
puts "P(name | userDesc): ", probLastNameDesc

mins = [probEnglishWordsDesc, probLastNameDesc]
min = mins.sort.last

if min == probEnglishWordsDesc
  puts "english"
elsif min == probLastNameDesc
  puts "name"
end
