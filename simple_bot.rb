# Simple bot emulator
class SimpleBot
  UNEXPECTED_PHRASE = "don't knows this phrase".freeze
  attr_reader :bot_name, :super_phrase

  def initialize(bot_name, super_phrase)
    @bot_name = bot_name
    @super_phrase = super_phrase
    @all_phrases = {}
  end

  def method_missing(method_name, *args)
    # check if method for adding new phrase
    if method_name =~ /^add_/
      add_phrase method_name, args
    elsif method_name =~ /^say_/
      actions_before_say method_name, args
    else
      say_unexpected_phrase || super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name =~ /^add_/ || method_name =~ /^say_/ || super
  end

  private

  # add new phrase to dictionary
  def add_phrase(method_name, args)
    key = method_name.to_s.sub(/^add_/, '')
    phrase = args.join(', ')
    @all_phrases[key] = phrase
    puts "#{super_phrase} The phrase '#{key}' successfully added!"
  end

  def actions_before_say(method_name, args)
    # check emotion symbol
    if method_name =~ /(\?|\!)$/
      emotion_char = method_name.to_s[-1]
      key = method_name.to_s.sub(/^say_/, '').chop
    else
      emotion_char = '.'
      key = method_name.to_s.sub(/^say_/, '')
    end

    check_all_phrases(key, emotion_char, args)
  end

  def check_all_phrases(key, emotion_char, args)
    if @all_phrases[key].nil?
      say_unexpected_phrase
    else
      phrase = args.join(', ')
      say_phrase key, emotion_char, phrase
    end
  end

  # get and output phrase from dictionary
  def say_phrase(key, emotion_char = '.', special_phrase = nil)
    if special_phrase.nil?
      puts @all_phrases[key].capitalize + emotion_char
    else
      puts "#{special_phrase.capitalize}," \
           "#{@all_phrases[key].downcase}#{emotion_char}"
    end
  end

  # output it if undefined phrase
  def say_unexpected_phrase
    puts "#{@bot_name} #{UNEXPECTED_PHRASE}!"
    true
  end
end

bot = SimpleBot.new('Vasia', 'Yeah!')

# add new phrase
bot.add_hello 'hello'

# say hello phrase
bot.say_hello 'User'

# say unexpected phrase
bot.hello 'User'

puts bot.respond_to? :hello
puts bot.respond_to? :say_hello
