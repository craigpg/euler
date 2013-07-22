class MaxProductFinder
  attr_reader :max_product, :sentence_length

  def initialize(sentence_length = 4)
    @sentence_length = sentence_length
    @max_product = 0
  end
  
  def each_row_proc
    lambda {|row| @max_product = [@max_product, max_product_in_row(row)].max }
  end
  
  def max_product_in_row(row)
    (0..row.length - sentence_length).inject(0) {|max, i| [max, row[i..(i + sentence_length - 1)].inject(&:*)].max}
  end

end

class RowCollector
  attr_reader :rows

  def initialize
    @rows = []
  end
  
  def each_row_proc
    lambda {|row| @rows << row }
  end
  
end

class Grid11
  attr_reader :grid

  def initialize(file_path)
    lines = File.readlines(file_path)
    @grid = lines.map(&:strip).select{|l| !l.empty?}.map{|l| l.strip.split.map(&:to_i)}
  end
  
  def solution(sentence_length = 4)
    finder = MaxProductFinder.new(sentence_length)
    horizontal_rows(finder.each_row_proc)
    vertical_cols(finder.each_row_proc)
    nw_to_se_diagonals(sentence_length, finder.each_row_proc)
    ne_to_sw_diagonals(sentence_length, finder.each_row_proc)
    finder.max_product
  end
  
  def rows(sentence_length = 4)
    row_collector = RowCollector.new
    horizontal_rows(row_collector.each_row_proc)
    vertical_cols(row_collector.each_row_proc)
    nw_to_se_diagonals(sentence_length, row_collector.each_row_proc)
    ne_to_sw_diagonals(sentence_length, row_collector.each_row_proc)
    row_collector.rows
  end

  private
  
  def collect_rows(row_proc_name, *args)
    [].tap {|rows| send(row_proc_name, *args) {|row| rows << row}}
  end
  
  def each_row()
    grid.each {|row| yield row } if block_given?
  end

  def horizontal_rows(row_proc = nil)
    if row_proc.nil?
      grid.map
    else
      grid.each {|r| row_proc.call(r)}
    end
  end

  def vertical_cols(row_proc = nil)
    if row_proc.nil?
      grid.transpose
    else
      grid.transpose.each {|r| row_proc.call(r)}
    end
  end
  
  def nw_to_se_diagonals(sentence_length = 4, row_proc = nil)
    [].tap do |diagonals|
      (0..(grid.length - sentence_length)).each do |r_idx|
        row = (0..grid.length - 1 - r_idx).map {|c_idx| grid[r_idx + c_idx][c_idx]}
        if row_proc.nil?
          diagonals << row
        else
          row_proc.call(row)
        end
      end
      (1..(grid.length - sentence_length)).to_a.reverse.each do |start_col|
        row = (start_col..(grid.length - 1)).map {|c_idx| grid[c_idx - start_col][c_idx]}
        if row_proc.nil?
          diagonals << row
        else
          row_proc.call(row)
        end
      end
    end
  end

  def ne_to_sw_diagonals(sentence_length = 4, row_proc = nil)
    [].tap do |diagonals|
      ((sentence_length - 1)..(grid.length - 1)).each do |start_col|
        row = (0..start_col).map {|r_idx| grid[r_idx][start_col - r_idx]}
        if row_proc.nil?
          diagonals << row
        else
          row_proc.call(row)
        end
      end
      (1..(grid.length - sentence_length)).each do |r_idx|
        row = (0..grid.length - 1 - r_idx).map {|c_idx| grid[r_idx + c_idx][grid.length - 1 - c_idx]}
        if row_proc.nil?
          diagonals << row
        else
          row_proc.call(row)
        end
      end
    end
  end
end
