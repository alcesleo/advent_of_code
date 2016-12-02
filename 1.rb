Position = Struct.new(:x, :y)

class Player
  attr_reader :winds, :position

  def initialize
    @winds    = [:north, :east, :south, :west].cycle
    @position = Position[0, 0]
  end

  def navigate(instructions)
    parse(instructions).each do |turns, blocks|
      turns.times do turn end
      blocks.times do walk end
    end
    nil
  end

  def manhattan_distance
    position.x.abs + position.y.abs
  end

  def parse(instructions)
    instructions.split(", ").map do |instruction|
      direction = instruction.chars.first
      blocks    = Integer(instruction[1..-1])

      turns = case direction
              when "R" then 1
              when "L" then 3
              else fail "Unrecognised direction"
              end

      [turns, blocks]
    end
  end

  def facing
    winds.peek
  end

  def turn
    winds.next
    nil
  end

  def walk(blocks = 1)
    case facing
    when :north then position.y += blocks
    when :south then position.y -= blocks
    when :east  then position.x += blocks
    when :west  then position.x -= blocks
    end
  end
end


require "minitest/spec"
require "minitest/autorun"

describe Player do
  let(:player) { Player.new }

  it "turns" do
    player.turn
    player.facing.must_equal :east

    player.turn
    player.facing.must_equal :south
  end

  it "walks" do
    player.walk
    player.position.must_equal Position[0, 1]

    player.turn
    player.walk(2)
    player.position.must_equal Position[2, 1]

    player.turn
    player.walk(2)
    player.position.must_equal Position[2, -1]

    player.turn
    player.walk(4)
    player.position.must_equal Position[-2, -1]
  end

  it "understands instructions" do
    player.parse("R2, L30").must_equal [[1, 2], [3, 30]]
  end

  it "follows instructions" do
    player.navigate("R2, L3").must_equal nil
    player.position.must_equal Position[2, 3]
  end

  it "calculates distance in blocks from its starting position" do
    player.navigate("R5, L5, R5, R3")
    player.manhattan_distance.must_equal 12
  end
end

### Find solution

# http://adventofcode.com/2016/day/1
INSTRUCTIONS = "R2, L1, R2, R1, R1, L3, R3, L5, L5, L2, L1, R4, R1, R3, L5, L5, R3, L4, L4, R5, R4, R3, L1, L2, R5, R4, L2, R1, R4, R4, L2, L1, L1, R190, R3, L4, R52, R5, R3, L5, R3, R2, R1, L5, L5, L4, R2, L3, R3, L1, L3, R5, L3, L4, R3, R77, R3, L2, R189, R4, R2, L2, R2, L1, R5, R4, R4, R2, L2, L2, L5, L1, R1, R2, L3, L4, L5, R1, L1, L2, L2, R2, L3, R3, L4, L1, L5, L4, L4, R3, R5, L2, R4, R5, R3, L2, L2, L4, L2, R2, L5, L4, R3, R1, L2, R2, R4, L1, L4, L4, L2, R2, L4, L1, L1, R4, L1, L3, L2, L2, L5, R5, R2, R5, L1, L5, R2, R4, R4, L2, R5, L5, R5, R5, L4, R2, R1, R1, R3, L3, L3, L4, L3, L2, L2, L2, R2, L1, L3, R2, R5, R5, L4, R3, L3, L4, R2, L5, R5"

p = Player.new
p.navigate(INSTRUCTIONS)

puts "The Easter Bunny HQ is at #{p.position}, which is #{p.manhattan_distance} blocks away."
