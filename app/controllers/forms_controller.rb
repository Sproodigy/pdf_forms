# encoding: utf-8

class ::Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end


class FormsController < ApplicationController
  def invoice
    order = {post_index: '443110', name: 'Африкантов Георгий Яковлевич',
      region: 'Нижегородская область',
      _store: { company: { juridical_title: 'ООО "Экстра"'} },
      line_items: [{product_title: 'Каша Здоровяк №32', quantity: 6, price: 125.0}]}
    pdf = InvoiceForm.new.to_pdf(order)
    send_data pdf, type: 'application/pdf', filename: 'invoice.pdf', disposition: 'inline'
  end

  def test
    pdf = TestForm.new.to_pdf
    send_data pdf, type: 'application/pdf', filename: 'test.pdf', disposition: 'inline'
  end

  def work
    pdf = WorkForm.new.to_pdf
    send_data pdf, type: 'application/pdf', filename: 'work.pdf', disposition: 'inline'
  end
end
