require "axlsx"

Axlsx::Package.new do |package|
  service = AxlsxSupportService.new
  styles = service.load_styles(package.workbook)
  sheet_name = "users_" + Time.zone.now.to_date.to_s

  package.workbook.add_worksheet(name: sheet_name) do |sheet|
    sheet.add_row %w(ID ユーザー名 最後の発言 発言日 発言状況), style: styles[:column_title]

    User.find_each do |user|
      sheet.add_row [
        user.id,
        user.id,
        user.id,
      ], style: [
        styles[:fill_zero],
        styles[:default],
        styles[:default],
      ]
    end
  end
end