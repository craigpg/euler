class Grid
  attr_reader :grid

  def initialize(file_path)
    lines = File.readlines(file_path)
    @grid = lines.map{|l| l.strip.split.map(&:to_i)}
  end
  
  def solution(sentence_length = 4)
    max_product(sentences_from_grid(sentence_length))
  end

  private
  
  def sentences_from_grid(sentence_length = 4)
    (rows.map{|row| sentences_from_row(row, sentence_length)} +
     cols.map{|row| sentences_from_row(row, sentence_length)} +
     nw_to_se_diagonals(sentence_length).map{|row| sentences_from_row(row, sentence_length)} +
     ne_to_sw_diagonals(sentence_length).map{|row| sentences_from_row(row, sentence_length)}).flatten(1)
  end
  
  def rows
    grid
  end

  def cols
    grid.transpose
  end
  
  def max_product(sentences)
    sentences.map{|w| w.inject(&:*)}.max
  end

  def sentences_from_row(row, sentence_length)
    (0..row.length - sentence_length).map {|i| row[i..(i + sentence_length - 1)]}
  end

  def nw_to_se_diagonals(sentence_length = 4)
    [].tap do |diagonals|
      (0..(grid.length - sentence_length)).each do |r_idx|
        diagonals << (0..grid.length - 1 - r_idx).map {|c_idx| grid[r_idx + c_idx][c_idx]}
      end
      (1..(grid.length - sentence_length)).map.reverse.each do |start_col|
        diagonals << (start_col..(grid.length - 1)).map {|c_idx| grid[c_idx - start_col][c_idx]}
      end
    end
  end

  def ne_to_sw_diagonals(sentence_length = 4)
    [].tap do |diagonals|
      ((sentence_length - 1)..(grid.length - 1)).each do |start_col|
        diagonals << (0..start_col).map {|r_idx| grid[r_idx][start_col - r_idx]}
      end
      (1..(grid.length - sentence_length)).each do |r_idx|
        diagonals << (0..grid.length - 1 - r_idx).map {|c_idx| grid[r_idx + c_idx][grid.length - 1 - c_idx]}
      end
    end
  end
end

grid = Grid.new('11-data.txt')
puts grid.solution(4)
