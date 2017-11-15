class UsersController < ApplicationController
  before_filter :require_login

  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      # index ページを表示するため html フォーマットについて記述
      format.html do
        @users = User.all
      end
      # index.xlsx.ruby がレンダーされる
      format.xlsx do
        send_data(
            render_to_string.to_stream.read,
            type: :xlsx,
            filename: "users_list_" + Time.zone.now.to_date.to_s + ".xlsx"
        )
      end
    end
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
    @q = User.search(params[:q])
    @users = @q.result(distinct: true)
  end

  def excel_import
    @users = User.all
  end

end
