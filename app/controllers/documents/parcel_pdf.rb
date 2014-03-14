# encoding: utf-8

module Documents
  class ParcelPdf
    INSTANCE_VARS = [:parcel_object, :weight, :order, :address, :zip, :region, :area, :city, :send_date, :cod_address, :barcode, :from_title, :from_addr, :from_tel, :cost_for_weight, :cost_for_decl, :total_delivery_cost, :to_name, :inn, :properties, :decl_amount_digit, :cod_amount_digit, :decl_amount, :cod_amount, :insurance_cost, :delivery_cost_vat]
    attr_accessor *INSTANCE_VARS

    include PostFormsFormatHelpers

    def initialize(parcel)
      @parcel_object = parcel
      @weight = parcel.weight                               # Вес
      @order = parcel.box_number                            # Номер заказа
      @zip = parcel.order.zip.to_s                          # Индекс
      @region = parcel.order.region
      @area = parcel.order.district
      @city = parcel.order.town
      @address_line = parcel.order.address
      @address = parcel.order.address + ",\n " + format_town_address(parcel.order) + ', ' + parcel.order.zip.to_s                             # Адрес получателя
      @send_date = parcel.send_date

      @barcode = parcel.num										              # Штрих-код
      @from_title = parcel.order.store.company.juridical_title # Отправитель
      @from_addr = parcel.order.store.company.address       # Адрес отправителя
      @cod_address = parcel.order.store.company.cod_address # Адрес наложенного платежа
      @from_tel = parcel.order.store.company.phone          # Телефон
      @cost_for_weight = parcel.delivery_cost               # Плата за вес
      @cost_for_decl = parcel.insurance_cost                # Плата за объявл. ценность
      @total_delivery_cost = parcel.total_delivery_cost     # Общая сумма(графа Всего)
      @to_name = parcel.order.name                          # Получатель
      @properties = parcel.order.store.company.bank_details # Реквизиты отправителя
      @inn = parcel.order.store.company.inn                 # ИНН отправителя
      @decl_amount_digit = parcel.value                     # Сумма объявленной ценности
      @cod_amount_digit = parcel.payment                    # Сумма наложенного платежа
      @insurance_cost = parcel.insurance_cost               # Страховой сбор
      @delivery_cost_vat = parcel.delivery_cost_vat
      @decl_amount = (RuPropisju.propisju_int(@decl_amount_digit.floor) + ' руб. ' +
          ((@decl_amount_digit-@decl_amount_digit.floor)*100).floor.to_s[0..1].rjust(2, '0') + ' коп.').mb_chars.capitalize # Сумма объявленной ценности(прописью)
      @cod_amount = (RuPropisju.propisju_int(@cod_amount_digit.floor) + ' руб. ' +
          ((@cod_amount_digit-@cod_amount_digit.floor)*100).floor.to_s[0..1].rjust(2, '0') + ' коп.').mb_chars.capitalize   # Сумма наложенного платежа(прописью)
    end


    def address_for_f103
      "#{@zip} #{format_town_address(@parcel_object.order)}\n#{@address_line}\n#{@to_name}"
    end

  end
end