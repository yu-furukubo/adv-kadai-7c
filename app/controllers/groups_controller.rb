class GroupsController < ApplicationController
  before_action :ensure_correct_owner, only: [:edit, :update, :destroy]

  def index
    @book = Book.new
    @groups = Group.all
    @user = User.find(current_user.id)
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
    @user = User.find(current_user.id)
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path, method: :post
    else
      render 'new'
    end
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render 'edit'
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end

  def join #メンバーイン
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to group_path(@group)
  end

  def out_of_group  #メンバーアウト
    @group = Group.find(params[:group_id])
    @group.users.delete(current_user)
    redirect_to group_path(@group)
  end

  def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @group = Group.find(params[:group_id])
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    EventMailer.send_mail(@mail_title,@mail_content,@group.users).deliver
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_owner
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
