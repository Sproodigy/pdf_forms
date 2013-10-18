# encoding: utf-8

class InquiryForm < Prawn::Document
  def to_pdf
    font_families.update(
      "DejaVuSans" => {
        normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
        bold: "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
        italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
        bold_italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf",
        extra_light: "#{Rails.root}/app/assets/fonts/DejaVuSans-ExtraLight.ttf",
        condensed: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed.ttf",
        condensed_bold: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed-Bold.ttf"
      })
    font "DejaVuSans", size: 8

    stroke_vertical_line 0, 540, :at => 385

    base_z = 530
    draw_text "Форма № МС-42", at: [315, base_z], size: 7
    draw_text "______________________________", at:[0, base_z-10], size: 10
    draw_text "(наименование предприятия связи)", at: [10, base_z-20], size: 7
    draw_text "Кассовая справка", at: [140, base_z-35], style: :bold, size: 10
    draw_text "оператора ____________________________________________", at: [50, base_z-50], size: 10
    draw_text "за __________________________ месяц 20     г.", at: [80, base_z-70], size: 10
    move_down 80

    my_table = make_table([ [{:content => "Сумма, руб. коп.", :colspan => 4}],
                            [{:content => "приход", :colspan => 2},
                            {:content => "расход", :colspan => 2}],
                           [{:content => "руб."},
                             {:content => "к."},
                             {:content => "руб."},
                             {:content => "к."}] 
                         ])

    
    #table([
    #        [{:content => "№ п/п", :width => 30},
    #         {:content => "Наименование операции", :width => 80},
    #         {:content => "Корреспон-дирующие счета (шифр операции)", :width => 60},
    #         my_table, "Основание"]
    #     ])

    table([ ["№ п/п", "Наименование операции", 
              "Корреспон-дирующие счета (шифр операции)", my_table,
              {:content => "Основание"}]],
               :column_widths => [30, 80, 60, 95] ) 
        
                     

    render

  end

end