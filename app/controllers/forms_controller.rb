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

  def form130
    pdf = Form130Form.new.to_pdf index: '443218', sum: 14045.94, quantity: 33
    send_data pdf, type: 'application/pdf', filename: 'form130.pdf', disposition: 'inline'
  end

  def prepayment
    pdf = PrepaymentForm.new.to_pdf
    send_data pdf, type: 'application/pdf', filename: 'prepayment.pdf', disposition: 'inline'
  end

  def inquiry
    pdf = InquiryForm.new(page_layout: :landscape, page_size: 'A4').to_pdf
    send_data pdf, type: 'application/pdf', filename: 'inquiry.pdf', disposition: 'inline'
  end 

  def backsideform117
    pdf = Backsideform117Form.new(page_layout: :landscape, page_size: 'A4').to_pdf
    send_data pdf, type: 'application/pdf', filename: 'backsideform117.pdf', disposition: 'inline'
  end 

  def backsideform113
    pdf = Backsideform113Form.new(page_layout: :landscape, page_size: 'A4').to_pdf
    send_data pdf, type: 'application/pdf', filename: 'backsideform113.pdf', disposition: 'inline'
  end

  def inquirybackside
    pdf = InquirybacksideForm.new(page_layout: :landscape, page_size: 'A4').to_pdf
    send_data pdf, type: 'application/pdf', filename: 'inquirybackside.pdf', disposition: 'inline'
  end  


  def form_f113_f117
    parcels = []
    output = Documents::PostFormF113117.new(page_layout: :landscape,
                                            page_size: 'A4',
                                            top_margin: 1, left_margin: 1, right_margin: 1, bottom_margin: 1
                                            ).to_pdf(parcels)
    send_data output, type: 'application/pdf', filename: 'form_f113_f117.pdf', disposition: 'inline'
  end

  def act
    pdf = ActForm.new(page_size: 'A4').to_pdf(num: 4899, date: Date.today,
      fulfiller: 'ООО "Экстра", ИНН/КПП 6316152650/631601001, 443068, г. Самара, ул. Ново-Садовая, д. 106, корп. 109',
      client: 'ООО МНПФ "Центр Новые Технологии", ИНН/КПП 6322025466/632401001, 445046, Самарская обл., г. Тольятти, ул. Лизы Чайкиной, д. 33, кв. 16',
      services: [['Почтовая подготовка', 55, 'шт.', 85], ['Складское хранение', 5, 'м. кв.', 490]],
      fulfiller_title: 'Директор',
      fulfiller_singer: 'Афанасьева М. В.',
      client_title: 'Гл. бухгалтер',
      client_singer: 'Петров С. Р.')
    send_data pdf, type: 'application/pdf', filename: 'act.pdf', disposition: 'inline'
  end

  def invoice_for_payment
    pdf = Invoice_for_paymentForm.new(page_size: 'A4').to_pdf
    send_data pdf, type: 'application/pdf', filename: 'invoice_for_payment.pdf', disposition: 'inline'
  end
 
 
end

