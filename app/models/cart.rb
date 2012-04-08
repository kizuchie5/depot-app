class Cart < ActiveRecord::Base
  attr_accessible :title, :body
  has_many :line_items, :dependent => :destroy
      #if cart is destroyed, so are line_items

  def add_product(product_id)
    current_item = line_items.where(:product_id => product_id).first
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(:product_id => product_id)
      current_item.price = current_item.product.price
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def total_items
    line_items.sum(:quantity)
  end

  def decrement_line_item_quantity(line_item_id)
    current_item = line_items.find(line_item_id)

    if current_item.quantity > 1
      current_item.quantity -= 1
    else
      current_item.destroy
    end

    current_item
  end
end
