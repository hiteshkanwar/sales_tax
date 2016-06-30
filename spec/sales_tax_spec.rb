require 'spec_helper'

describe SalesTax do

  before :each do
    @sales_tax = SalesTax.new
    @items =  [
                [1, 'book', 12.49], [1, 'music cd', 14.99], 
                [ 1, 'chocolate bar', 0.85 ] 
              ]
  end

  describe "#calculate_total" do

    it "takes three parameters" do
      lambda {@sales_tax.calculate_tax_total 1,'book'}.should raise_exception ArgumentError
    end

    it "calculate sales total of items" do
      expected_sales_total = 1.5
      @items.each do |item|
        @result = @sales_tax.calculate_tax_total item[0],item[1],item[2]
      end

      @result.should eql 1.5
    end

  end  

  it "#total" do
    expected_total = 29.83
    @items.each do |item|
      @sales_tax.calculate_tax_total item[0],item[1],item[2]
    end  
    total = @sales_tax.total

    total.should eql 29.83
  end

end