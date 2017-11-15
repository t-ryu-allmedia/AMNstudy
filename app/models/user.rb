class User < ActiveRecord::Base
  require 'rubyXL'
  authenticates_with_sorcery!

  has_many :tweets, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :follows, foreign_key: :follower_id
  has_many :inverse_followers, through: :follows
  has_many :inverse_follows, foreign_key: :inverse_follower_id, class_name: Follow
  has_many :followers, through: :inverse_follows

  validates :name, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z][a-z0-9]+\z/ }, length: { in: 4..24 }
  validates :screen_name, length: { maximum: 140 }
  validates :bio, length: { maximum: 200  }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, confirmation: true, length: { in: 6..24 }, if: :password
  validates :password_confirmation, presence: true, if: :password

  def followed_by? user
    inverse_follows.where(follower_id: user.id).exists?
  end

  def  first_tweets
    tweets.first
  end

  def current_month_first_tweets?
    first_tweets.created_at.month == DateTime.now.month
  end

  def self.excel_import(users)
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = 'test'
    worksheet.add_cell(0, 0, 'id')
    worksheet.add_cell(0, 1, '名前')
    worksheet.add_cell(0, 2, '最後の発言')
    worksheet.add_cell(0, 3, '発言日')
    worksheet.add_cell(0, 4, '発言状況')
    users.each.with_index(1) do |user, row_idx|
      worksheet.add_cell(row_idx, 0, user.id)
      worksheet.add_cell(row_idx, 1, user.name)
      if user.first_tweets.present?
        worksheet.add_cell(row_idx, 2, user.first_tweets.content)
        worksheet.add_cell(row_idx, 3, user.first_tweets.created_at.strftime("%Y年 %m月 %d日 %H:%M:%S"))
        worksheet.add_cell(row_idx, 4, user.current_month_first_tweets? ? "○" : "×")
      else
        worksheet.add_cell(row_idx, 2, "×")
        worksheet.add_cell(row_idx, 3, "×")
        worksheet.add_cell(row_idx, 4, "×")
        end
      end
    workbook.write('public/sample.xlsx')
  end
end
