require "digest/md5"

class DoorCracker
  attr_reader :hasher

  def initialize
    @hasher = Digest::MD5.new
  end

  def crack(door_id)
    password = ""
    counter = 1

    until password.length == 8
      hash = hasher.hexdigest([door_id, counter].join)
      password << hash[5] if hash.start_with?("00000")
      counter += 1
    end

    password
  end
end

require "minitest/spec"
require "minitest/autorun"

describe DoorCracker do
  it "cracks passwords" do
    DoorCracker.new.crack("abc").must_equal "18f47a30"
  end
end

puts "The code is #{DoorCracker.new.crack("reyedfim")}"
