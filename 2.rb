Position = Struct.new(:x, :y)

BASIC_KEYPAD_LAYOUT = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9],
]

STRANGE_KEYPAD_LAYOUT = [
  [nil, nil, 1,   nil, nil],
  [nil, 2,   3,   4,   nil],
  [5,   6,   7,   8,   9],
  [nil, "A", "B", "C", nil],
  [nil, nil, "D", nil, nil],
]

class Keypad
  attr_reader :position, :layout, :pressed_buttons

  def initialize(layout, position)
    @layout = layout
    @position = position
    @pressed_buttons = []
  end

  def punch_code(instructions)
    instructions.split("\n").each do |sequence|
      sequence.chars.each do |direction|
        move_finger(direction)
      end

      press
    end
  end

  def button
    layout[position.y][position.x]
  end

  def code
    pressed_buttons.join
  end

  def press
    self.pressed_buttons << button
  end

  def move_finger(direction)
    resulting_position = case direction
                         when "U" then Position[position.x, position.y - 1]
                         when "D" then Position[position.x, position.y + 1]
                         when "L" then Position[position.x - 1, position.y]
                         when "R" then Position[position.x + 1, position.y]
                         end

    self.position = resulting_position if within_layout?(resulting_position)
  end

  private

  attr_writer :button, :position

  def within_layout?(position)
    return false if position.x < 0 || position.y < 0
    return false if layout.fetch(position.y, [])[position.x].nil?
    true
  end
end

require "minitest/spec"
require "minitest/autorun"

describe Keypad do
  let(:keypad) { Keypad.new(BASIC_KEYPAD_LAYOUT, Position[1, 1]) }

  it "moves the finger" do
    fake_layout = [
      [1, 2, 3],
      [nil, 5, nil],
      [7, 8, 9],
    ]
    keypad = Keypad.new(fake_layout, Position[1, 1])

    keypad.move_finger("U")
    keypad.button.must_equal 2
    keypad.move_finger("U")
    keypad.button.must_equal 2

    keypad.move_finger("D")
    keypad.button.must_equal 5

    keypad.move_finger("R")
    keypad.button.must_equal 5

    keypad.move_finger("L")
    keypad.button.must_equal 5

    keypad.move_finger("D")
    keypad.button.must_equal 8
    keypad.move_finger("D")
    keypad.button.must_equal 8

    keypad.move_finger("L")
    keypad.button.must_equal 7
    keypad.move_finger("L")
    keypad.button.must_equal 7

    keypad.move_finger("R")
    keypad.button.must_equal 8
    keypad.move_finger("R")
    keypad.button.must_equal 9
    keypad.move_finger("R")
    keypad.button.must_equal 9
  end

  it "presses buttons" do
    keypad.move_finger("U")
    keypad.press

    keypad.move_finger("D")
    keypad.press

    keypad.move_finger("L")
    keypad.press

    keypad.code.must_equal "254"
  end

  it "follows instructions" do
    keypad.punch_code(<<~TEXT)
      ULL
      RRDDD
      LURDL
      UUUUD
    TEXT

    keypad.code.must_equal "1985"
  end
end

input = DATA.read
keypad = Keypad.new(BASIC_KEYPAD_LAYOUT, Position[1, 1])
keypad.punch_code(input)
puts "The code with a basic keypad layout isis #{keypad.code}"

keypad = Keypad.new(STRANGE_KEYPAD_LAYOUT, Position[0, 2])
keypad.punch_code(input)
puts "The code with a fucked up keypad layout isis #{keypad.code}"

__END__
UDRLRRRUULUUDULRULUDRDRURLLDUUDURLUUUDRRRLUUDRUUDDDRRRLRURLLLDDDRDDRUDDULUULDDUDRUUUDLRLLRLDUDUUUUDLDULLLDRLRLRULDDDDDLULURUDURDDLLRDLUDRRULDURDDLUDLLRRUDRUDDDLLURULRDDDRDRRLLUUDDLLLLRLRUULRDRURRRLLLLDULDDLRRRRUDRDULLLDDRRRDLRLRRRLDRULDUDDLDLUULRDDULRDRURRURLDULRUUDUUURDRLDDDURLDURLDUDURRLLLLRDDLDRUURURRRRDRRDLUULLURRDLLLDLDUUUDRDRULULRULUUDDULDUURRLRLRRDULDULDRUUDLLUDLLLLUDDULDLLDLLURLLLRUDRDLRUDLULDLLLUDRLRLUDLDRDURDDULDURLLRRRDUUDLRDDRUUDLUURLDRRRRRLDDUUDRURUDLLLRRULLRLDRUURRRRRLRLLUDDRLUDRRDUDUUUDRUDULRRULRDRRRDDRLUUUDRLLURURRLLDUDRUURDLRURLLRDUDUUDLLLUULLRULRLDLRDDDU
DRRRDRUDRLDUUDLLLRLULLLUURLLRLDRLURDRDRDRLDUUULDRDDLDDDURURUDRUUURDRDURLRLUDRRRDURDRRRDULLRDRRLUUUURLRUULRRDUDDDDUURLDULUDLLLRULUDUURRDUULRRDDURLURRUDRDRLDLRLLULULURLRDLRRRUUURDDUUURDRDRUURUDLULDRDDULLLLLRLRLLUDDLULLUDDLRLRDLDULURDUDULRDDRLUDUUDUDRLLDRRLLDULLRLDURUDRLRRRDULUUUULRRLUDDDLDUUDULLUUURDRLLULRLDLLUUDLLUULUULUDLRRDDRLUUULDDRULDRLURUURDLURDDRULLLLDUDULUDURRDRLDDRRLRURLLRLLLLDURDLUULDLDDLULLLRDRRRDLLLUUDDDLDRRLUUUUUULDRULLLDUDLDLURLDUDULRRRULDLRRDRUUUUUURRDRUURLDDURDUURURULULLURLLLLUURDUDRRLRRLRLRRRRRULLDLLLRURRDULLDLLULLRDUULDUDUDULDURLRDLDRUUURLLDLLUUDURURUD
UDUUUUURUDLLLRRRDRDRUDDRLLDRRLDRLLUURRULUULULRLLRUDDRLDRLUURDUDLURUULLLULLRRRULRLURRDDULLULULRUDDDUURDRLUDUURRRRUUULLRULLLDLURUDLDDLLRRRULDLLUURDRRRDRDURURLRUDLDLURDDRLLLUUDRUULLDLLLLUUDRRURLDDUDULUDLDURDLURUURDUUUURDLLLRUUURDUUUDLDUDDLUDDUDUDUDLDUDUUULDULUURDDLRRRULLUDRRDLUDULDURUURULLLLUDDDLURURLRLRDLRULRLULURRLLRDUDUDRULLRULRUDLURUDLLDUDLRDRLRDURURRULLDDLRLDDRLRDRRDLRDDLLLLDUURRULLRLLDDLDLURLRLLDULRURRRRDULRLRURURRULULDUURRDLURRDDLDLLLRULRLLURLRLLDDLRUDDDULDLDLRLURRULRRLULUDLDUDUDDLLUURDDDLULURRULDRRDDDUUURLLDRDURUDRUDLLDRUD
ULRDULURRDDLULLDDLDDDRLDUURDLLDRRRDLLURDRUDDLDURUDRULRULRULULUULLLLDRLRLDRLLLLLRLRRLRLRRRDDULRRLUDLURLLRLLURDDRRDRUUUDLDLDRRRUDLRUDDRURRDUUUDUUULRLDDRDRDRULRLLDLDDLLRLUDLLLLUURLDLRUDRLRDRDRLRULRDDURRLRUDLRLRLDRUDURLRDLDULLUUULDRLRDDRDUDLLRUDDUDURRRRDLDURRUURDUULLDLRDUDDLUDDDRRRULRLULDRLDDRUURURLRRRURDURDRULLUUDURUDRDRLDLURDDDUDDURUDLRULULURRUULDRLDULRRRRDUULLRRRRLUDLRDDRLRUDLURRRDRDRLLLULLUULRDULRDLDUURRDULLRULRLRRURDDLDLLRUUDLRLDLRUUDLDDLLULDLUURRRLRDULRLRLDRLDUDURRRLLRUUDLUURRDLDDULDLULUUUUDRRULLLLLLUULDRULDLRUDDDRDRDDURUURLURRDLDDRUURULLULUUUDDLRDULDDLULDUDRU
LRLRLRLLLRRLUULDDUUUURDULLLRURLDLDRURRRUUDDDULURDRRDURLRLUDLLULDRULLRRRDUUDDRDRULLDDULLLUURDLRLRUURRRLRDLDUDLLRLLURLRLLLDDDULUDUDRDLRRLUDDLRDDURRDRDUUULLUURURLRRDUURLRDLLUDURLRDRLURUURDRLULLUUUURRDDULDDDRULURUULLUDDDDLRURDLLDRURDUDRRLRLDLRRDDRRDDRUDRDLUDDDLUDLUDLRUDDUDRUDLLRURDLRUULRUURULUURLRDULDLDLLRDRDUDDDULRLDDDRDUDDRRRLRRLLRRRUUURRLDLLDRRDLULUUURUDLULDULLLDLULRLRDLDDDDDDDLRDRDUDLDLRLUDRRDRRDRUURDUDLDDLUDDDDDDRUURURUURLURLDULUDDLDDLRUUUULRDRLUDLDDLLLRLLDRRULULRLRDURRRLDDRDDRLU
