class SubmitRequestsController < ApplicationController
  before_action :set_submit_request, only: [:show, :edit, :update, :destroy]
  before_action :submit_params,only: [:approve, :unapprove, :reject]
  before_action :authenticate_user!

  def index
    @submit_requests = SubmitRequest.where(user_id: current_user.id).order(updated_at: :desc)
  end

  def new
    # 相互フォローユーザー
    @users = current_user.friend
    # 自分が作成した未完了タスク
    @tasks = current_user.tasks.where(done: false)
    # フォーム送信用に取得
    @user = current_user
    # リクエスト新規作成用
    @submit_request = current_user.submit_requests.build(status: 1)
  end

  def create
    @submit_request = SubmitRequest.new(submit_request_params)
    respond_to do |format|
      if @submit_request.save
       @submit_request.task.update(charge_id: submit_request_params[:charge_id])
        format.html { redirect_to user_submit_requests_path(current_user.id), notice: '依頼を送信しました。' }
        format.json { render :show, status: :created, location: @submit_request }
      else
        format.html { render :new }
        format.json { render json: @submit_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
    # 相互フォローユーザー
    @users = current_user.friend
    # 自分が作成した未完了タスク
    @tasks = current_user.tasks.where(done: false)
  end

  def update
    respond_to do |format|
      if @submit_request.update(submit_request_params)
       @submit_request.task.update(charge_id: submit_request_params[:charge_id])
       format.html { redirect_to user_submit_requests_path(current_user.id, @submit_request), notice: '依頼を編集しました。'}
       format.json { render :show, status: :ok, location: @submit_request }
     else
      format.html { render :edit }
      format.json { render json: @submit_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @submit_request.destroy
    respond_to do |format|
      format.html { redirect_to user_submit_requests_url(current_user.id), notice: '依頼を削除しました。' }
      format.json { head :no_content }
    end
  end

  def approve
   @submit_request.update(status: 2)
    @submit_requests = SubmitRequest.where(charge_id: current_user.id).order(updated_at: :desc)
    respond_to do |format|
      format.js { render :reaction_inbox }
    end
  end

  def unapprove
    @submit_request.update(status: 9)
    @submit_request.task.update(charge_id: @submit_request.user_id)
    # @submit_request.task.update(status: 9, charge_id: @submit_request.user_id)
    @submit_requests = SubmitRequest.where(charge_id: current_user.id).order(updated_at: :desc)
    respond_to do |format|
      format.js { render :reaction_inbox }
    end
  end

  def reject
     @submit_request.update(status: 8)
    # @submit_request.task.update(status: 8, charge_id: current_user.id)
    @submit_requests = SubmitRequest.where(charge_id: current_user.id).order(updated_at: :desc)
    respond_to do |format|
      format.js { render :reaction_inbox }
    end
end

  def inbox
    @submit_requests = SubmitRequest.where(charge_id: current_user.id).order(updated_at: :desc)
  end

private

  def submit_request_params
    params.require(:submit_request).permit(:task_id, :user_id, :charge_id, :status, :message)
  end

  def set_submit_request
    @submit_request = SubmitRequest.find(params[:id])
  end

  def submit_params
    @submit_request = SubmitRequest.find(params[:submit_request_id].to_i)
 end
end
