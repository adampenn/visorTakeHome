#!/usr/bin/ruby

Dir.chdir("/home/adam/visor_take_home")

# Read in description and split it into words
w2Dictionary = File.read('w2_learn_files/W2_Learn_File.txt').split("\n")
f1099Dictionary = File.read('1099_learn_files/1099_Learn_File.txt').split("\n")

w2NumDesc = w2Dictionary.size
f1099NumDesc = f1099Dictionary.size

w2Dictionary = File.read('w2_learn_files/W2_Learn_File.txt').split(/\W+/)
f1099Dictionary = File.read('1099_learn_files/1099_Learn_File.txt').split(/\W+/)

# Read in description from user
userDesc = File.read(ARGV[0]).split(/\W+/)
userDesc = userDesc.uniq

# init laplace smoothing value and number of classes
k = 1
cl = 5

# Count the occurances of each words
w2Count = Array.new
tmpIndiv = Array.new
# init w2Count
i = 0
w2Dictionary.each do |x|
  if tmpIndiv.index(x)
    j = tmpIndiv.index(x)
    w2Count[j] = w2Count[j]+1
  else
    w2Count[i] = 1;
    tmpIndiv.push(x)
    i = i + 1
  end
end
w2Dictionary = w2Dictionary.uniq

# init f1099Count
f1099Count = Array.new
tmpIndiv = Array.new
i = 0
f1099Dictionary.each do |x|
  if tmpIndiv.index(x)
    j = tmpIndiv.index(x)
    f1099Count[j] = f1099Count[j]+1
  else
    f1099Count[i] = 1;
    tmpIndiv.push(x)
    i = i + 1
  end
end
f1099Dictionary = f1099Dictionary.uniq

dictionary = w2Dictionary+f1099Dictionary
dictionary = dictionary.uniq
dictionarySize = dictionary.size

probw2 = (w2NumDesc+k).to_f/((w2NumDesc+f1099NumDesc)+(k*cl)).to_f
probf1099 = (f1099NumDesc+k).to_f/((w2NumDesc+f1099NumDesc)+(k*cl)).to_f

# Calculate P(userWord | w2)
# puts "\nCalculate P(userWord | w2)", "-"*50
userProbw2 = Array.new
userDesc.each do |x|
  if(w2Dictionary.index(x))
    tmp = (w2Count[w2Dictionary.index(x)]+k).to_f/(w2Dictionary.size+(k*dictionarySize)).to_f
  else
    tmp = k.to_f/(w2Dictionary.size+(k*dictionarySize)).to_f
  end
  userProbw2.push(tmp)
  # puts "P(#{x}|w2) = #{tmp}"
end

# Calculate P(userWord | f1099)
# puts "\nCalculate P(userWord | f1099)", "-"*50
userProbf1099 = Array.new
userDesc.each do |x|
  if(f1099Dictionary.index(x))
    tmp = (f1099Count[f1099Dictionary.index(x)]+k).to_f/(f1099Dictionary.size+(k*dictionarySize)).to_f
  else
    tmp = k.to_f/(f1099Dictionary.size+(k*dictionarySize)).to_f
  end
  userProbf1099.push(tmp)
  # puts "P(#{x}|f1099) = #{tmp}"
end

# Calculate P(userDesc | w2)
probDescw2 = 0
userProbw2.each do |x|
  if probDescw2 == 0
    probDescw2 = x
  else
    probDescw2 = probDescw2 * x
  end
end

# Calculate P(userDesc | f1099)
probDescf1099 = 0
userProbf1099.each do |x|
  if probDescf1099 == 0
    probDescf1099 = x
  else
    probDescf1099 = probDescf1099 * x
  end
end

# puts "probDescf1099 " , probDescf1099, "  probDescw2 ", probDescw2

# Calculate P(w2 | userDesc)
probw2Desc = (probDescw2*probw2)/((probDescw2*probw2)+(probDescf1099*probf1099))

# Calculate P(f1099 | userDesc)
probf1099Desc = (probDescf1099*probf1099)/((probDescw2*probw2)+(probDescf1099*probf1099))

#puts "P(f1099 | userDesc): ", probf1099Desc
#puts "P(w2 | userDesc): ", probw2Desc

mins = [probf1099Desc, probw2Desc]
min = mins.sort.last

if min == probf1099Desc
  puts "1099"
elsif min == probw2Desc
  puts "W2"
end
