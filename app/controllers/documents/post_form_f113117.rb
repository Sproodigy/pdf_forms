# encoding: utf-8
module Documents
  class PostFormF113117 < PostFormsPdfDocument
    def to_pdf(parcels)
      prepare_fonts

      parcels.each do |parcel|
        # A4:: => 595.28 x 841.89

        print_f117(0, 0, parcel)

        print_f113(420, 0, parcel) if parcel.parcel_object.order.postpaid?

        start_new_page unless (parcel == parcels.last)
      end
      render
    end
    
  end
end