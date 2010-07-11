class TextCaptcha
  
  OPTIONS =
  [
    'Granville',
    'Robson',
    'Stanley',
    'Victory',
    'Yaletown',
    'Gastown',
    'Arbutus',
    'Ridge',
    'Dunbar',
    'Fairview',
    'Kerrisdale',
    'Kitsilano',
    'Marpole',
    'Oakridge',
    'Grandview',
    'Hastings',
    'Kensingtion',
    'Killarney',
    'Renfrew',
    'Victoria',
    'Pleasant',
    'Riley',
    'Strathcona',
	  'Burnaby',
	  'Coquitlam',
	  'Delta',
	  'Langley',
	  'Richmond',
	  'Surrey'     
    ]
  
  def self.valid?(hash, answer)
    return false if hash.blank? || answer.blank?
    hash.strip.to_i == generate_hash(answer.strip)
  end
 
  def self.generate_hash( answer )
    hash = 0
    answer.downcase.each_byte { |b| hash += b }
    hash                     
  end
  
  def self.generate()
    answer = OPTIONS[ rand( OPTIONS.size) ]
    hash = generate_hash( answer )
    [ hash, answer ]
  end
  
end
