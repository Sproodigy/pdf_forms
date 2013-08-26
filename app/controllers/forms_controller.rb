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
    order = {_zip: '443045', name: 'Спрут Богдан Евгеньевич',
      region: 'Самарская область', country: 'Россия',
      town: 'Самара', adress: 'ул. Артёмовская 22, кв. 28', telephone: '8 937 659-81-89',
      _store: { company: { juridical_title: 'ООО "Экстра"', _zip: 443110, address: 'г. Самара, ул. Новая, д. 106, корп. 2', phone: '(846) 221-64-49'} },
      line_items: [{product_title: 'Каша Здоровяк №32', quantity: 3, price: 125.0},
                   {product_title: 'Каша Здоровяк №36', quantity: 6, price: 10025.0},
                   {product_title: 'Каша Здоровяк №83', quantity: 9, price: 100000.0}] }

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
