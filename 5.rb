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

  def crack_secure(door_id)
    password = [nil] * 8
    counter = 1

    until password.compact.length == password.length
      hash = hasher.hexdigest([door_id, counter].join)
      counter += 1

      next unless hash.start_with?("00000")

      index = hash[5]
      next unless index =~ /[0-9]/

      index = index.to_i
      next unless index.to_i < password.length

      password[index] = hash[6] if password[index].nil?
    end

    password.join
  end
end

require "minitest/spec"
require "minitest/autorun"

describe DoorCracker do
  it "cracks passwords" do
    DoorCracker.new.crack("abc").must_equal "18f47a30"
  end

  it "crack 'secure' passwords" do
    DoorCracker.new.crack_secure("abc").must_equal "05ace8e3"
  end
end

puts "The code is #{DoorCracker.new.crack("reyedfim")}"
puts "The second code is #{DoorCracker.new.crack_secure("reyedfim")}"
