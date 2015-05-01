module PDFFormattingMixin
  def subtitle(pdf, text)
    pdf.move_down 10
    pdf.text(text, style: :italic, size: 11, inline_format: true)
    pdf.move_down 5
  end

  def title(pdf, text)
    pdf.text(text, style: :bold, inline_format: true)
  end

  def line(pdf, options = Hash.new)
    pdf.move_down 5
    pdf.text('_' * 52, options)
    pdf.move_down 5
  end
end
