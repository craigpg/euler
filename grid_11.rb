class Grid11
  attr_reader :grid

  def initialize(file_path)
    lines = File.readlines(file_path)
    @grid = lines.map(&:strip).select{|l| !l.empty?}.map{|l| l.strip.split.map(&:to_i)}
  end
  
  def solution(sentence_length = 4)
    [max_product_in_rows(rows, sentence_length),
     max_product_in_rows(cols, sentence_length),
     max_product_in_rows(nw_to_se_diagonals(sentence_length), sentence_length),
     max_product_in_rows(ne_to_sw_diagonals(sentence_length), sentence_length)].max
  end

  private
  
  def rows
    grid
  end

  def cols
    grid.transpose
  end
  
  def max_product_in_rows(rows, sentence_length)
    rows.inject(0){|max, row| [max, max_product_in_row(row, sentence_length)].max}
  end

  def max_product_in_row(row, sentence_length)
    (0..row.length - sentence_length).inject(0) {|max, i| [max, row[i..(i + sentence_length - 1)].inject(&:*)].max}
  end

  def nw_to_se_diagonals(sentence_length = 4)
    [].tap do |diagonals|
      (0..(grid.length - sentence_length)).each do |r_idx|
        diagonals << (0..grid.length - 1 - r_idx).map {|c_idx| grid[r_idx + c_idx][c_idx]}
      end
      (1..(grid.length - sentence_length)).to_a.reverse.each do |start_col|
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
