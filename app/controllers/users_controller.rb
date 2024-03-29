# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetimes
#  remember_created_at    :datetime
#  user_id                :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page => params[:page], :per_page => params[:per_page] ||= 30).order(remember_created_at: :desc)

  end


  # GET /users/1
  # GET /users/1.json
  def show

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:alert] = "The user you're looking for cannot be found"
      respond_to do |format|
        format.html {
          redirect_to users_path
        }
        format.json {render :json, status: 404}
      end
    rescue => e
      flash[:alert] = "Something went wrong"
      respond_to do |format|
        format.html {
          redirect_to users_path
        }
        format.json {render :json, status: 418}
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.fetch(:user).permit(:email, :password, :encrypted_password)
  end


end
