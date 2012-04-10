Order.transaction do
  (1..100).each do |i|
    Order.create(:name => "Loki #{i}", :address => "#{i} Spirit World",
      :email => "loki-#{i}@heartoflucy.com", :pay_type => "Check")
  end
end