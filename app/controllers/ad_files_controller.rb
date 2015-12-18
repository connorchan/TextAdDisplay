class AdFilesController < ApplicationController
  
  before_action :authenticate_user!
  around_filter :catch_not_found
  
  def index
    @user = current_user
    @adfile = @user.ad_files.all
  end

  def new
    @adfile = AdFile.new
  end

  def create
    @user = current_user
    @adfile = AdFile.new(ad_file_params)
    if @adfile.save
      @user.ad_files << @adfile
      redirect_to ad_files_path, notice: "Your CSV has been uploaded."
    else
      flash[:notice] = "File type invalid. Please upload a valid CSV file."
      render "new"
    end
    
  end

  def destroy
    @user = current_user
    @adfile = @user.ad_files.find(params[:id])
    @adfile.destroy
    redirect_to ad_files_path, notice: "The files have been deleted."
  end

  def show
    @disable_nav = true
    @user = current_user
    @adfile = @user.ad_files.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@adfile.name}",
        :template => 'ad_files/show.pdf.html.erb',
        :layout => 'pdf.html.erb'
      end
    end
  end
  
  private
  
  def ad_file_params
    params.require(:ad_file).permit(:name, :platform, :text_ad_file)
  end
  
  def catch_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url, :flash => { :notice => "You do not have permission to access that file." }
  end
  
  
end
