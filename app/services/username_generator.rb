class UsernameGenerator
  ADJECTIVES = %w[
    Epic Awesome Legendary Mysterious Magical
    Brave Clever Swift Mighty Radiant
    Cosmic Galactic Stellar Lunar Solar
    Pixelated Retro Arcade Classic Vintage
    Digital Virtual Cyber Neon Glitch
    Heroic Warrior Champion Knight Paladin
    Wizard Sorcerer Mage Enchanter Alchemist
    Ninja Samurai Rogue Assassin Shadow
    Dragon Phoenix Griffin Unicorn Kraken
  ].freeze

  NOUNS = %w[
    Gamer Player Hero Warrior Knight
    Wizard Mage Sorcerer Druid Alchemist
    Ninja Samurai Rogue Assassin Thief
    Dragon Phoenix Griffin Unicorn Kraken
    Pixel Sprite Character Avatar Legend
    Quest Adventure Journey Mission Campaign
    Realm Kingdom Empire Domain Universe
    Code Byte Data Chip Circuit
    Level Stage World Map Dungeon
    Sword Shield Bow Staff Wand
  ].freeze

  def self.generate
    adjective = ADJECTIVES.sample
    noun = NOUNS.sample
    number = rand(100..999)
    
    "#{adjective}#{noun}#{number}"
  end
end 