require 'spec_helper'
 
describe Grid11 do

  def sentence_product(sentence)
    sentence.inject(&:*)
  end

  #
  # a 5x5 is minimum grid size to test with to validate diagonals
  #
  context "with a 5x5 grid" do
    before :all do
        @grid = Grid11.new "./spec/fixtures/five_by_five_grid.txt"
        @rows = @grid.rows
    end

    it "should have a total of 16 rows" do
      @rows.count.should == 16
    end
    
    it "should have 5 horizontal rows" do
      @rows.should include([8, 2, 22, 97, 38])
      @rows.should include([49, 49, 99, 40, 17])
      @rows.should include([81, 49, 31, 73, 55])
      @rows.should include([52, 70, 95, 23, 4])
      @rows.should include([22, 31, 16, 71, 51])
    end

    it "should have 5 vertical columns" do
      @rows.should include([8, 49, 81, 52, 22])
      @rows.should include([2, 49, 49, 70, 31])
      @rows.should include([22, 99, 31, 95, 16])
      @rows.should include([97, 40, 73, 23, 71])
      @rows.should include([38, 17, 55, 4, 51])
    end
    
    it "should have 3 nw_to_se diagonals" do
      @rows.should include([49, 49, 95, 71])
      @rows.should include([8, 49, 31, 23, 51])
      @rows.should include([2, 99, 73, 4])
    end
    
    it "should have 3 ne_to_sw diagonals" do
      @rows.should include([97, 99, 49, 52])
      @rows.should include([38, 40, 31, 70, 22])
      @rows.should include([17, 73, 95, 31])
    end
    
    it "should find the correct solution" do
      # "manual" solution based on rows / cols / diagonals we expect
      solution = [ sentence_product([8, 2, 22, 97]),    # row 1
                   sentence_product([2, 22, 97, 38]),   # row 1
                   sentence_product([49, 49, 99, 40]),  # row 2
                   sentence_product([49, 99, 40, 17]),  # row 2
                   sentence_product([81, 49, 31, 73]),  # row 3
                   sentence_product([49, 31, 73, 55]),  # row 3
                   sentence_product([52, 70, 95, 23]),  # row 4
                   sentence_product([70, 95, 23, 4]),   # row 4
                   sentence_product([22, 31, 16, 71]),  # row 5
                   sentence_product([31, 16, 71, 51]),  # row 5
                   sentence_product([8, 49, 81, 52]),   # col 1
                   sentence_product([49, 81, 52, 22]),  # col 1
                   sentence_product([2, 49, 49, 70]),   # col 2
                   sentence_product([49, 49, 70, 31]),  # col 2
                   sentence_product([22, 99, 31, 95]),  # col 3
                   sentence_product([99, 31, 95, 16]),  # col 3
                   sentence_product([97, 40, 73, 23]),  # col 4
                   sentence_product([40, 73, 23, 71]),  # col 4
                   sentence_product([38, 17, 55, 4]),   # col 5
                   sentence_product([17, 55, 4, 51]),   # col 5
                   sentence_product([49, 49, 95, 71]),  # nw_to_se 1
                   sentence_product([8, 49, 31, 23]),   # nw_to_se 2
                   sentence_product([49, 31, 23, 51]),  # nw_to_se 2
                   sentence_product([2, 99, 73, 4]),    # nw_to_se 3
                   sentence_product([97, 99, 49, 52]),  # ne_to_sw 1
                   sentence_product([38, 40, 31, 70]),  # ne_to_sw 2
                   sentence_product([40, 31, 70, 22]),  # ne_to_sw 2
                   sentence_product([17, 73, 95, 31])   # ne_to_sw 3
                   ].max
      @grid.solution.should == solution
    end
  end
  
  context "with a MaxProductFinder" do
    before :each do
      @max_product_finder = MaxProductFinder.new(4)
    end
    
    it "should be initialized correctly" do
      @max_product_finder.max_product.should == 0
    end

    context "with a single row with 5 words" do
      before :each do
        @row = "08 02 22 97 38".split.map(&:to_i)
      end
      it "should find the sentence with the max product of its words" do
        @max_product_finder.each_row_proc.call(@row)
        @max_product_finder.max_product.should == 162184
      end
    end

    context "with a 2 rows" do
      before :each do
        @rows = ["08 02 22 97".split.map(&:to_i), "02 22 97 38".split.map(&:to_i)]
      end
      it "should find max product" do
        @rows.each {|row| @max_product_finder.each_row_proc.call(row) }
        @max_product_finder.max_product.should == 162184
      end
    end
  end

  context "with a RowCollector" do
    before :each do
      @row_collector = RowCollector.new
    end
    
    it "should be initialized correctly" do
      @row_collector.rows.should be_empty
    end

    context "with a single row with 5 words" do
      before :each do
        @row = "08 02 22 97 38".split.map(&:to_i)
      end
      it "should find the sentence with the max product of its words" do
        @row_collector.each_row_proc.call(@row)
        @row_collector.rows.should == [@row]
      end
    end

    context "with a 2 rows" do
      before :each do
        @rows = ["08 02 22 97".split.map(&:to_i), "02 22 97 38".split.map(&:to_i)]
      end
      it "should find max product" do
        @rows.each {|row| @row_collector.each_row_proc.call(row) }
        @row_collector.rows.should == @rows
      end
    end
  end

end