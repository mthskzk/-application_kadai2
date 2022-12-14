class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @post_comment=PostComment.new
  end

  def index
    @book = Book.new
    if params[:latest]
      @books=Book.latest
    elsif params[:old]
      @books=Book.old
    elsif params[:score_count]
      @books=Book.score_count
    else
      @books = Book.all
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :score)
  end

  def is_matching_login_user
    book=Book.find(params[:id])
    user_id=book.user_id
    login_user_id=current_user.id
    if(user_id != login_user_id)
      redirect_to books_path
    end
  end

end
