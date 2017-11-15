class UsersController < ApplicationController
  before_filter :require_login

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  def favorites
    @user = User.find(params[:id])
  end

  def follows
    @user = User.find(params[:id])
  end

  def followers
    @user = User.find(params[:id])
  end

  def check_list
    respond_to do |format|
      # index ページを表示するため html フォーマットについて記述
      format.html do
        @q = User.search(params[:q])
        @users = @q.result(distinct: true)
      end
      # index.xlsx.ruby がレンダーされる
      format.xlsx do
        @q = User.search(params[:q])
        @users = @q.result(distinct: true)
        User.excel_import(@users)
        file_path = "#{Rails.root.to_s}/public/sample.xlsx"
        send_file file_path,
                  filename: "sample.xlsx",
                  type:"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      end
    end
  end

  private

  def generate_xlsx
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: "シート名") do |sheet|
        sheet.add_row ["First Column", "Second", "Third"]
        sheet.add_row [1, 2, 3]
      end
      send_data(p.to_stream.read,
                type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                filename: "sample.xlsx")
    end
  end
end
