require "csv"

class SalesTax

  def initialize
    @total_sales_tax = @total = 0.0;
    generate_csv "quantity", "product", "price", "tax"
  end

  def calculate_tax_total quantity, product, price
    product = product.downcase

    tax_free_category = identify_category product
    @sales_tax = 0.0

    if product.include? "imported"
      #If product categories not belongs to - Book, Food, Medical
      if !tax_free_category
        @sales_tax = ( quantity * price )*(imported_sales_tax)
      else  
        @sales_tax = ( quantity * price )*imported_tax_free_sales_tax
      end

    elsif !tax_free_category
      @sales_tax = ( quantity * price )*sales_tax
    end

    generate_csv quantity, product, price,  @sales_tax
    @total +=  (quantity*price)
    @total_sales_tax += @sales_tax.round(2)

  end

  def identify_category product
    if product.include? "book"
      return true
    elsif product.include? "chocolate"
      return true
    elsif product.include? "pills"
      return true
    else
      return false 
    end
  end

  def total        
    total_amt = (@total+@total_sales_tax.round(1)).round(2)
    generate_csv '',"Grand total:", total_amt
    generate_csv '','Total tax: ',@total_sales_tax
    return total_amt
  end

  private

    def imported_sales_tax
      sales_tax+imported_tax_free_sales_tax 
    end

    def sales_tax
      (10.to_f/100)
    end

    def imported_tax_free_sales_tax
      (5.to_f/100)
    end

    def generate_csv *row
      CSV.open("bill.csv", "a+") do |csv|
        csv << row
      end
    end
end

sales_tax = SalesTax.new

#items = [[1, 'book', 12.49], [1, 'music cd', 14.99], [ 1, 'chocolate bar', 0.85 ]]
#items= [[1, 'imported box of chocolates', 10.50], [1 ,'imported bottle of perfume', 54.65]]

items =  [ [1, 'imported bottle of perfume', 27.99],  [1, 'bottle of perfume', 18.99], [1, 'packet of headache pills', 9.75], [1, 'box of imported chocolates', 11.25]]

items.each do |item|
  sales_tax.calculate_tax_total( item[0], item[1], item[2] )
end

print sales_tax.total