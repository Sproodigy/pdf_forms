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

  def form113en
    pdf = Form113enForm.new.to_pdf(fulfiller: 'ООО "Экстра"', barcode: 32389209822998,
      address: 'г. Самара, а/я 4001',
      inn: 631614265880,
      index: 443110,
      remittor: 'Иванов Иван Иванович',
      remittor_address: 'ул. Лейтенанта Шмидта, д. 3, корп. 39, кв. 15 МОСКВА, МОСКОВСКАЯ ОБЛАСТЬ, РОССИЯ')
    send_data pdf, type: 'application/pdf', filename: 'form113en.pdf', disposition: 'inline'
	end

	def backform113en
		pdf = Backform113enForm.new.to_pdf
		send_data pdf, type: 'application/pdf', filename: 'backform113en.pdf', disposition: 'inline'
	end

  def act
    pdf = ActForm.new.to_pdf(num: 4899, date: Date.today,
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
    pdf = Invoice_for_paymentForm.new.to_pdf(num: 8493, date: Date.today,
      adress: '443068, г. Самара, ул. Ново-Садовая д. 106, корп. 109',
      tel: 'Тел.: 8-800-100-31-01',
      line_items: [ ['Каша "Самарский Здоровяк" №48', 'шт.', 5, 125], ['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125] ],
      client: 'ООО "Медхелп", ИНН/КПП 3662175880/366201001, 394026, г. Воронеж, ул. Варейкиса, 70',
      receiver: 'ООО "Экстра"',
      inn: '6316152650',
      kpp: '631601001',
      account: '40702810029180000336',
      bik: '042202824',
      corr_account: '30101810200000000824',  
      bank: 'ФИЛИАЛ "НИЖЕГОРОДСКИЙ" ОАО "АЛЬФА-БАНК" Г.НИЖНИЙ НОВГОРОД',
      singer: 'Афанасьева Марина Васильевна')
    send_data pdf, type: 'application/pdf', filename: 'invoice_for_payment.pdf', disposition: 'inline'
  end

  def form22
	  pdf = Form22Form.new.to_pdf
	  send_data pdf, type: 'application/pdf', filename: 'form22.pdf', disposition: 'inline'
  end

  def backform22
	  pdf = Backform22Form.new.to_pdf
	  send_data pdf, type: 'application/pdf', filename: 'backform22.pdf', disposition: 'inline'
  end
 
 
end

