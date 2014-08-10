class Form112epForm < Prawn::Document

	def print_form112ep(sender:, receiver:, sender_address:, receiver_address:, tel:, value:, payment:,
	                    date:, mailings_code:, weight:, packaging:, put:)

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
		font "DejaVuSans", size: 9
stroke_vertical_line 0, 750, at: 2
		image 'app/assets/images/cybermoney.png', at: [0, cursor], width: 82
		image 'app/assets/images/russian_post_blue_logo.png', at: [3, cursor-20], width: 79

		text 'ф. 112ЭП', align: :right

		dash [2,2]
		font_size 10
		transparent(0.3) do
			bounding_box [100, 700], width: 269, height: 98 do
				text 'Зона оттиска ККМ', align: :center, valign: :center
				stroke_bounds
			end
			bounding_box [395, 700], width: 108, height: 98 do
				stroke_bounds
			end
		end
		undash

		draw_text 'ПРИЁМ', at: [45, 650], size: 10
		draw_text '№______________', at: [7, 640], size: 10
		draw_text '(по накладной ф. 16)', at: [21, 632], size: 6
		stroke_rectangle [9, 630], 82, 45
		stroke_rectangle [11, 628], 15, 15
		stroke_horizontal_line 28, 79, at: 613
		stroke_horizontal_line 11, 79, at: 600
		draw_text 'Контроль', at: [7, 591], rotate: 90, size: 7
		draw_text '(дата)', at: [21, 164], size: 6
		draw_text '(подпись)', at: [17, 158], size: 6

		text_box 'Являетесь ли Вы должностным лицом публичных международных организаций или лицом, замещающим (занимающим) гос. должности РФ, должности членов Совета директоров Центрального банка РФ, должности федеральной гос. службы, назначение на которые и освобождение от которых осуществляется Президентом РФ или Правительством РФ, должности в Центральном банке РФ, гос. компаниях и иных организациях, созданных РФ на основании Федеральных законов, включенных в перечни должностей, определяемые Президентом РФ? (на основании федерального закона №231-ФЗ от 18 декабря 2006 г.)',
		         at: [9, 130], width: 500, size: 6
		text_box "В целях осуществления данного почтового перевода подтверждаю свое согласие:\n- на обработку как автоматизированным, так и неавтоматизированным способом указанных на бланке персональных данных; (Закон №152-ФЗ от 14 июля 2006 г.)\n- на передачу информации о номере почтового перевода, о событии (о перечислении
 почтового перевода на счет получателя, о дате и месте совершения события).",
		         at: [9, 17.5], width: 500, size: 6


	end

end