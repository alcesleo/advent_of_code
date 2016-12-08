class Display
  attr_reader :width, :height, :on, :off, :visualize, :pixels

  def initialize(width:, height:, on: "#", off: ".", visualize: false)
    @width     = width
    @height    = height
    @on        = on
    @off       = off
    @visualize = visualize

    @pixels = height.times.map { [off] * width }
  end

  def draw
    puts pixels.map(&:join)
  end

  def perform_operation(instruction)
    case instruction
    when /rect (\d+)x(\d+)/               then rect($1.to_i, $2.to_i)
    when /rotate row y=(\d+) by (\d+)/    then rotate_row($1.to_i, $2.to_i)
    when /rotate column x=(\d+) by (\d+)/ then rotate_column($1.to_i, $2.to_i)
    end

    if visualize
      system "clear"
      draw
      sleep 0.05
    end
  end

  def count_lit_pixels
    pixels.map { |row| row.count { |pixel| pixel == on } }.inject(&:+)
  end

  private

  attr_writer :pixels

  def rect(w, h)
    (0...w).each do |row|
      (0...h).each do |column|
        pixels[column][row] = on
      end
    end
  end

  def rotate_row(index, by)
    by.times do
      self.pixels[index] = pixels[index].unshift(pixels[index].pop)
    end
  end

  def rotate_column(index, by)
    self.pixels = pixels.transpose
    rotate_row(index, by)
    self.pixels = pixels.transpose
  end
end

require "minitest/spec"
require "minitest/autorun"

describe Display do
  subject { Display.new(width: 7, height: 3) }

  it "performs operations" do
    -> { subject.draw }.must_output(<<~OUTPUT)
      .......
      .......
      .......
    OUTPUT

    subject.perform_operation("rect 3x2")
    -> { subject.draw }.must_output(<<~OUTPUT)
      ###....
      ###....
      .......
    OUTPUT

    subject.perform_operation("rotate column x=1 by 1")
    -> { subject.draw }.must_output(<<~OUTPUT)
      #.#....
      ###....
      .#.....
    OUTPUT

    subject.perform_operation("rotate row y=0 by 4")
    -> { subject.draw }.must_output(<<~OUTPUT)
      ....#.#
      ###....
      .#.....
    OUTPUT

    subject.perform_operation("rotate column x=1 by 1")
    -> { subject.draw }.must_output(<<~OUTPUT)
      .#..#.#
      #.#....
      .#.....
    OUTPUT

    subject.count_lit_pixels.must_equal 6
  end
end

input = DATA.read
display = Display.new(width: 50, height: 6, on: "█", off: " ", visualize: true)

input.split("\n").each do |instruction|
  display.perform_operation(instruction)
end

puts "Number of lit pixels is #{display.count_lit_pixels}"

__END__
rect 1x1
rotate row y=0 by 6
rect 1x1
rotate row y=0 by 3
rect 1x1
rotate row y=0 by 5
rect 1x1
rotate row y=0 by 4
rect 2x1
rotate row y=0 by 5
rect 2x1
rotate row y=0 by 2
rect 1x1
rotate row y=0 by 5
rect 4x1
rotate row y=0 by 2
rect 1x1
rotate row y=0 by 3
rect 1x1
rotate row y=0 by 3
rect 1x1
rotate row y=0 by 2
rect 1x1
rotate row y=0 by 6
rect 4x1
rotate row y=0 by 4
rotate column x=0 by 1
rect 3x1
rotate row y=0 by 6
rotate column x=0 by 1
rect 4x1
rotate column x=10 by 1
rotate row y=2 by 16
rotate row y=0 by 8
rotate column x=5 by 1
rotate column x=0 by 1
rect 7x1
rotate column x=37 by 1
rotate column x=21 by 2
rotate column x=15 by 1
rotate column x=11 by 2
rotate row y=2 by 39
rotate row y=0 by 36
rotate column x=33 by 2
rotate column x=32 by 1
rotate column x=28 by 2
rotate column x=27 by 1
rotate column x=25 by 1
rotate column x=22 by 1
rotate column x=21 by 2
rotate column x=20 by 3
rotate column x=18 by 1
rotate column x=15 by 2
rotate column x=12 by 1
rotate column x=10 by 1
rotate column x=6 by 2
rotate column x=5 by 1
rotate column x=2 by 1
rotate column x=0 by 1
rect 35x1
rotate column x=45 by 1
rotate row y=1 by 28
rotate column x=38 by 2
rotate column x=33 by 1
rotate column x=28 by 1
rotate column x=23 by 1
rotate column x=18 by 1
rotate column x=13 by 2
rotate column x=8 by 1
rotate column x=3 by 1
rotate row y=3 by 2
rotate row y=2 by 2
rotate row y=1 by 5
rotate row y=0 by 1
rect 1x5
rotate column x=43 by 1
rotate column x=31 by 1
rotate row y=4 by 35
rotate row y=3 by 20
rotate row y=1 by 27
rotate row y=0 by 20
rotate column x=17 by 1
rotate column x=15 by 1
rotate column x=12 by 1
rotate column x=11 by 2
rotate column x=10 by 1
rotate column x=8 by 1
rotate column x=7 by 1
rotate column x=5 by 1
rotate column x=3 by 2
rotate column x=2 by 1
rotate column x=0 by 1
rect 19x1
rotate column x=20 by 3
rotate column x=14 by 1
rotate column x=9 by 1
rotate row y=4 by 15
rotate row y=3 by 13
rotate row y=2 by 15
rotate row y=1 by 18
rotate row y=0 by 15
rotate column x=13 by 1
rotate column x=12 by 1
rotate column x=11 by 3
rotate column x=10 by 1
rotate column x=8 by 1
rotate column x=7 by 1
rotate column x=6 by 1
rotate column x=5 by 1
rotate column x=3 by 2
rotate column x=2 by 1
rotate column x=1 by 1
rotate column x=0 by 1
rect 14x1
rotate row y=3 by 47
rotate column x=19 by 3
rotate column x=9 by 3
rotate column x=4 by 3
rotate row y=5 by 5
rotate row y=4 by 5
rotate row y=3 by 8
rotate row y=1 by 5
rotate column x=3 by 2
rotate column x=2 by 3
rotate column x=1 by 2
rotate column x=0 by 2
rect 4x2
rotate column x=35 by 5
rotate column x=20 by 3
rotate column x=10 by 5
rotate column x=3 by 2
rotate row y=5 by 20
rotate row y=3 by 30
rotate row y=2 by 45
rotate row y=1 by 30
rotate column x=48 by 5
rotate column x=47 by 5
rotate column x=46 by 3
rotate column x=45 by 4
rotate column x=43 by 5
rotate column x=42 by 5
rotate column x=41 by 5
rotate column x=38 by 1
rotate column x=37 by 5
rotate column x=36 by 5
rotate column x=35 by 1
rotate column x=33 by 1
rotate column x=32 by 5
rotate column x=31 by 5
rotate column x=28 by 5
rotate column x=27 by 5
rotate column x=26 by 5
rotate column x=17 by 5
rotate column x=16 by 5
rotate column x=15 by 4
rotate column x=13 by 1
rotate column x=12 by 5
rotate column x=11 by 5
rotate column x=10 by 1
rotate column x=8 by 1
rotate column x=2 by 5
rotate column x=1 by 5
