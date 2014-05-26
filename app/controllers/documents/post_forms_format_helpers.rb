module Documents
  module PostFormsFormatHelpers
    def format_currency(value)
      number_with_precision(value, precision: 2, delimiter: ' ')
    end
    alias_method :fc, :format_currency

    def format_currency_cut_fractional(value)
      number_with_precision(value, precision: 0, delimiter: ' ')
    end
    alias_method :fcc, :format_currency_cut_fractional

    def format_weight(weight)
      number_with_precision(weight, precision: 3)
    end

    def format_barcode(barcode)
      barcode = barcode.to_s
      barcode.insert(6, ' ').insert(9, ' ').insert(15, ' ')
    end

    def format_town_address(order)
      ((order.town.present? ? order.town + ", " : "") + (order.district.present? ? order.district + ", " : "") + (order.region.present? ? order.region : "")).mb_chars.upcase.to_s
    end

    def to_currency_string(value)
      value = BigDecimal.new(value.to_s)
      propisju = RuPropisju.rublej(value).mb_chars.upcase.to_s
      propisju += ' ' + ((value-value.floor)*100).round.to_i.to_s[0..1].rjust(2, '0') + ' КОП.' if value > 0

      "#{format_currency(value)} (#{propisju})"
    end

  end
end