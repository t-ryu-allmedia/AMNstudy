class AxlsxSupportService
  # セルのカスタム書式設定を読み込む
  def load_styles(workbook)
    default_font_family = "ＭＳ Ｐゴシック"

    styles = {}
    styles[:default] = workbook.styles.add_style(font_name: default_font_family)
    styles[:column_title] = workbook.styles.add_style(font_name: default_font_family, b: true, alignment: { horizontal: :center }, bg_color: "f9ef93")
    styles[:fill_zero] = workbook.styles.add_style(font_name: default_font_family, format_code: "0000000000")
    styles
  end
end