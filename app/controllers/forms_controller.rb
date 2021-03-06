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
    pdf = Form130Form.new
		pdf.print_form130(index: '443218', sum: 14045.94, quantity: 33, date: Date.today)
    send_data pdf.render, type: 'application/pdf', filename: 'form130.pdf', disposition: 'inline'
  end

  def prepayment
    pdf = PrepaymentForm.new
		pdf.print_prepayment
    send_data pdf.render, type: 'application/pdf', filename: 'prepayment.pdf', disposition: 'inline'
  end

  def inquiry
    pdf = InquiryForm.new
		pdf.print_inquiry
    send_data pdf.render, type: 'application/pdf', filename: 'inquiry.pdf', disposition: 'inline'
  end

  def inquiry_back
	  pdf = InquiryForm.new
		pdf.print_inquiry_back
	  send_data pdf.render, type: 'application/pdf', filename: 'inquiry_back.pdf', disposition: 'inline'
  end

  Mailing = Struct.new *%i{num company order send_date batch value payment weight}
  Company = Struct.new *%i{juridical_title address inn index}
  Order = Struct.new *%i{name zip address region area city id}
  Batch = Struct.new *%i{company send_date mailings}

  def form117
	  order = Order.new('Васисуалий Геннадий Викторович', 101000, 'ул. Ленина, д. 23, кв. 11', 'Москва', '', '', 1234)
	  company = Company.new('ООО "Экстра"', 'ул. Ново-Садовая 106, корп. 109', '632323423424', 443110)
	  batch = Batch.new(company, Date.today)
	  mailing = Mailing.new 443123_63_00023_9, company, order, Date.today, batch, 123400, 123400, 6235.00
		pdf = Form117Form.new(page_layout: :landscape, page_size: 'A4').print_f117_from_mailing(-15, 0, mailing)
		send_data pdf, type: 'application/pdf', filename: 'form117.pdf', disposition: 'inline'
  end

  def form117_back
    pdf = Form117Form.new(page_layout: :landscape, page_size: 'A4').print_form117_back
    send_data pdf, type: 'application/pdf', filename: 'form117_back.pdf', disposition: 'inline'
  end

  def form113
		order = Order.new('Васисуалий Геннадий Викторович', 101000, 'ул. Ленина, д. 23, кв. 11', 'Москва', '', '', 1234)
		company = Company.new('ООО "Экстра"', 'ул. Ново-Садовая 106, корп. 109', '632323423424', 443110)
		batch = Batch.new(company, Date.today)
		mailing = Mailing.new 443123_63_00023_9, company, order, Date.today, batch, 1234, 1234, 6235.00
	  pdf = Form113Form.new(page_layout: :landscape, page_size: 'A4').print_f113_from_mailing(-15, 0, mailing)
	  send_data pdf, type: 'application/pdf', filename: 'form113.pdf', disposition: 'inline'
  end

  def form113_back
    pdf = Form113Form.new(page_layout: :landscape, page_size: 'A4').print_form113_back
    send_data pdf, type: 'application/pdf', filename: 'form113_back.pdf', disposition: 'inline'
  end

  def form113en
    pdf = Form113enForm.new.print_f113en(payment: '99999' + '  руб.  ' + '00' + ' коп.', receiver: 'ООО "Экстра"', barcode: 32389209822998,
      receiver_address: 'Самарская область, г. Самара, ул. Галактионовская 385, корпус 893, кв. 389',
      inn: 631614265880,
      account: 40702810029180000336,
      corr_account: 89389823283290239932,
      bik: 983370328,
      index: 443110,
      sender: 'Иванов Иван Иванович',
      sender_address: "ул. Лейтенанта Шмидта, д. 3, корп. 39, кв. 15\nМОСКВА, МОСКОВСКАЯ ОБЛАСТЬ, РОССИЯ")
    send_data pdf, type: 'application/pdf', filename: 'form113en.pdf', disposition: 'inline'
  end

  def form113en_mailing
		order = Order.new('Васисуалий', 10100, 'ул. Ленина, д. 23, кв. 11', 'Москва', '', '')
		company = Company.new('ООО "Экстра"', 'ул. Ново-Садовая 106, корп. 109', '632323423424', 443110)
		mailing = Mailing.new 443123_63_00023_9, company, order
    pdf = Form113enForm.new.print_f113en_from_mailing(mailing)
    send_data pdf, type: 'application/pdf', filename: 'form113en.pdf', disposition: 'inline'
	end

	def backform113en
		pdf = Form113enForm.new.print_f113en_back
		send_data pdf, type: 'application/pdf', filename: 'backform113en.pdf', disposition: 'inline'
	end

  def act
    pdf = ActForm.new
		pdf.print_act(num: 4899, date: Date.today,
      fulfiller: 'ООО "Экстра", ИНН/КПП 6316152650/631601001, 443068, г. Самара, ул. Ново-Садовая, д. 106, корп. 109',
      client: 'ООО МНПФ "Центр Новые Технологии", ИНН/КПП 6322025466/632401001, 445046, Самарская обл., г. Тольятти, ул. Лизы Чайкиной, д. 33, кв. 16',
      services: [['Почтовая подготовка', 55, 'шт.', 85], ['Складское хранение', 5, 'м. кв.', 490]],
      fulfiller_title: 'Директор',
      fulfiller_signer: 'Афанасьева М. В.',
      client_title: 'Гл. бухгалтер',
      client_signer: 'Петров С. Р.')
    send_data pdf.render, type: 'application/pdf', filename: 'act.pdf', disposition: 'inline'
  end

  def invoice_for_payment
    pdf = Invoice_for_paymentForm.new
		pdf.print_invoice_for_payment(num: 8493, date: Date.today,
			contract: '1.1 "Поставщик" обязуется отгрузить товар, а "Покупатель" - принять товар и оплатить его "Поставщику" на условиях настоящего договора-счёта.
                         1.2. Право собственности на товар переходит к "Покупателю" от "Поставщика" в момент передачи товара.
												 1.3. Риск случайной гибели определяется в соответствии с действующим гражданским законодательством РФ.
                         1.4. Оплата товара осуществляется перечислением денежных средств на расчетный счет "Поставщика", в размере 100% (ста процентов) предоплаты.
												 1.5. Стоимость товаров указана без НДС (продавец находится на УСН).
												 1.6. Товар считается оплаченным с момента поступления денежных средств на расчетный счет «Поставщика».
												 1.7. Оплата, произведенная по настоящему договору-счету "Покупателем", означает акцептование и подписание им настоящего договора-счета.
												 Стоимость товара, указанная в настоящем договоре-счете, действительна в течение 5-х (трех) банковских дней с момента его направления
                				 (по факсу или электронной почте). В случае, если оплата произведена «Покупателем» за пределами указанного срока, "Поставщик" вправе
												 изменить цену и выставить новый договор-счет на суммовую разницу в связи с изменением цены, а "Покупатель" обязуется его оплатить.
												 1.8. Поставка товара осуществляется после полной оплаты при условии наличия товара на складе "Поставщика".
												 1.9. Поставка/Отправка грузов получателю осуществляется транспортной компанией Деловые Линии за счет получателя.
 											   1.10. Гарантийные обязательства выполняются согласно срокам и порядку, указанному для конкретного товара (артикула) в договоре-счете и карточке (техническом паспорте) товара.
												 1.11. Договор-счет составлен в двух экземплярах, имеющих одинаковую силу, по одному для каждой из сторон.',
      address: '443068, г. Самара, ул. Ново-Садовая д. 106, корп. 155, офис 421',
      tel: 'Тел.: 8-800-100-31-01',
      line_items: [ ['Каша "Самарский Здоровяк" №48', 'шт.', 5, 125], ['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125],
										['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125], ['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125],
										['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125], ['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125],
										['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125], ['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125],
										['Каша "Самарский Здоровяк" №48', 'шт.', 5, 125], ['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125],
										['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125], ['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125],
										['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125], ['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125],
										['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125], ['Каша "Самарский Здоровяк" №42', 'шт.', 38, 125]],
			#client: 'ООО "Промстройформат", г. Зеленоград, ул. Градостоительная 35, корп. 108, кв. 389, ИНН: 6316152348, КПП: 8982983',
      client:{num: '33890', bank: 'ФИЛИАЛ "НИЖЕГОРОДСКИЙ" ОАО "АЛЬФА-БАНК" Г.НИЖНИЙ НОВГОРОД', bik: '4423424', account: '40702810029180000336',
							corr_account: '30101810200000000824',	inn: '6316152650', kpp: '631601001', tel: 'Тел.: 8-800-100-31-01', name: 'ООО Трали-вали',
							signer: 'Алыбердыев Джамерхан Алибабаевич',	proxy: '8933898',
							address: 'г. Истанбул, Истанбульский р-он, Республика Казахстан, ул. Ходжы Насреддина 231, корп. 48, кв. 133'},
      receiver: 'ООО "Экстра"',
      inn: '6316152650',
      kpp: '631601001',
      account: '40702810029180000336',
      bik: '042202824',
      corr_account: '30101810200000000824',
      bank: 'ФИЛИАЛ "НИЖЕГОРОДСКИЙ" ОАО "АЛЬФА-БАНК" Г.НИЖНИЙ НОВГОРОД',
		signer: 'Версилов Станислав Игоревич')
    send_data pdf.render, type: 'application/pdf', filename: 'invoice_for_payment.pdf', disposition: 'inline'
  end

  def search
	  pdf = SearchForm.new
	  pdf.print_search(sender:'Версилов Станислав Игоревич',
	                   mail_type: 'Посылка',
	                   mail_ctg: 'Ценная',
	                   sender_address: 'ул. Ново-Садовая 106, корп. 109, г. Самара, Самарская область, Россия, Тел: 8-937-233-83-32',
	                   receiver: 'Абдурахманов Герхан Закиреевич',
	                   receiver_address: 'г. Истанбул, Истанбульский р-он, Республика Казахстан, ул. Ходжы Насреддина 231, корп. 48, кв. 133, Тел: 8-233-329-23-38',
	                   value: 53489,
	                   payment: 53489,
	                   date: Date.today,
	                   barcode: 44312364892300,
	                   weight: 4932,
	                   packaging: 'Гофротара',
	                   content: 'Пищевые добавки')
	  send_data pdf.render, type: 'application/pdf', filename: 'search.pdf', disposition: 'inline'
  end

  def form22_back
	  pdf = Form22Form.new.print_form22_back
	  send_data pdf, type: 'application/pdf', filename: 'form22_back.pdf', disposition: 'inline'
  end

  def form22
	  pdf = Form22Form.new
	  pdf.print_form22(x: 0, y: 0, doc_num: 1, receiver: 'Сорокиной Оксане Александровне',
	                   receiver_address: 'Самарская обл., Новокуйбышевский р-он, г. Новокуйбышевск, ул. Сергея Лазо, д. 323, кв. 893',
	                   mailing_type: 'группа РПО (2 шт.)', weight: 3.389,
	                   value: 382.3, payment: 382.3, delivery_cost: 328.3)
	  send_data pdf.render, type: 'application/pdf', filename: 'form22.pdf', disposition: 'inline'
  end

  def form112ep
	  pdf = Form112epForm.new
	  pdf.print_form112ep(sender:'ООО "Экстра"',
	                      sender_address: 'Россия, Самарская область, г. Самара, ул. Ново-Садовая 106, корпус 109',
												sender_tel: 89348990211,
												sender_index: 443123,
												bank: 'Альфа-Банк в Самаре',
												inn: 631614265880,
												account: 40702810029180000336,
												corr_account: 89389823283290239932,
												bik: 983370328,
												receiver_index: 443110,
	                      receiver: 'Мингазалиев Абдурахман Гиззатуллович оглы',
	                      receiver_address: 'Республика Казахстан, Брахманский район, село Брахмачарьевское, ул. Сулеймановская 321, кв. 329',
	                      receiver_tel: 88934389309,
	                      payment: 4534,
	                      mail_payment: 8997,
	                      date: Date.today,
	                      mail_ctg: 'payment',
	                      sms_ctg_1: 'delivery at door',
	                      sms_ctg_2: 'at notice')
	  send_data pdf.render, type: 'application/pdf', filename: 'form112ep.pdf', disposition: 'inline'
  end

  def form_ems
	  pdf = FormEMS.new.print_form_ems
	  send_data pdf, type: 'application/pdf', filename: 'form_ems.pdf', disposition: 'inline'
  end

  def form_table
    pdf = FormTable.new.print_form_table
    send_data pdf, type: 'application/pdf', filename: 'form_table.pdf', disposition: 'inline'
  end

 end
