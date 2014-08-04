class SearchForm < Prawn::Document

	def print_search

		font_families.update(
				"DejaVuSans" => {
						normal: "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
						bold: "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
						italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-Oblique.ttf",
						bold_italic: "#{Rails.root}/app/assets/fonts/DejaVuSans-BoldOblique.ttf",
						extra_light: "#{Rails.root}/app/assets/fonts/DejaVuSans-ExtraLight.ttf",
						condensed: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed.ttf",
						bold: "#{Rails.root}/app/assets/fonts/DejaVuSansCondensed-Bold.ttf"
				})
		font "DejaVuSans", size: 9

		formatted_text_box [{text: "\nКому:  "}, {text: 'Начальнику Омельченко В. М.', styles: [:bold]},
		                    {text: "\nОт: "}, {text: 'Версилова Станислава Игоревича', styles: [:bold]},
		                    {text: "\nПроживающего: "}, {text: 'ул. Ново-Садовая 106, корп. 109, г. Самара,
											Самарская область, Россия',
		                                                 styles: [:bold]},
		                    {text: "\nТел: "}, {text: '8-937-389-32-83', styles: [:bold]},
		                    {text: "\nДокумент, удостоверяющий личность:  "}, {text: 'паспорт', styles: [:bold]},
		                    {text: "\nСерия: "}, {text: '3903' + ' ' * 20, styles: [:bold]}, {text: '№:'},
		                    {text: ' 903237', styles: [:bold]},
		                    {text: "\nВыдан: "}, {text: 'Октябрьским РОВД г. Самары', styles: [:bold]}],
		                   at: [230, 750], width: 350

		draw_text 'ЗАЯВЛЕНИЕ', at: [230, cursor-80], style: :bold, size: 12
		# bounding_box([0, 700], width: 300) do
		# 	text "Кому:  " + "<b>Начальнику Омельченко Владимиру Николаевичу</b>", style: :condensed_condensed_
	#bold
		# 	text 'От: ' + '<b>Версилова Станислава Игоревича</b>', inline_format: true
		# end

	end

end