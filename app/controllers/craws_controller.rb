class CrawsController < ApplicationController
  before_action :set_craw, only: [:show, :edit, :update, :destroy]

  # GET /craws
  # GET /craws.json
  def index
    @craws = Craw.all
    @images=[]
    @sumary =[]
    @address = []
    @info =[]
    @properties = []
    @avatar_url = ""
    url_get_data = 'https://www.foody.vn/hue/saigon-morin-hotel/'
    url_get_data = params[:url] if params[:url].present?
    #Khởi tạo object
    agent = Mechanize.new
    # agent.user_agent_alias = 'Windows Chrome'
    # agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    #Fetch page
    begin
      page = agent.get(url_get_data) do |pages|
        @avatar_url = (pages.search ".pic-place").first.attributes["src"].text

        sumaries = pages.search ".microsite-top-points"
        sumaries.each_with_index do |sumary, index|
          @sumary << sumary.text.to_s.gsub!(/\r\n|\r|\n/, ' ')
        end

        @address <<  (pages.search '.res-common-add').text.gsub!(/\r\n|\r|\n/, ' ')
        @address <<  (pages.search '.res-common-phone').text.gsub!(/\r\n|\r|\n/, ' ').gsub!(/\r\n|\r|\n/, ' ')
        @address <<  (pages.search '.res-common-price').text.gsub!(/\r\n|\r|\n/, ' ')

        info = (pages.search ".special-content li")
        info.each_with_index do |f, index|
          @info << f.text.to_s.gsub!(/\r\n|\r|\n/, ' ')
        end

        info_sec = pages.search ".new-detail-info-area"
        info_sec.each do |f|
          @info << f.text.to_s.gsub!(/\r\n|\r|\n/, ' ')
        end

        properties = pages.search ".micro-property li"

        properties.each_with_index do |property, index|
          @properties << property.text.to_s.gsub!(/\r\n|\r|\n/, ' ') unless property.attr('class') && property.attr('class').include?('none')
        end

        link_to_album = []
        link_to_albums =pages.search '.img-album-mon-an, .img-album-thuc-don, .img-album-khong-gian, .img-album-tong-hop'
        link_to_albums.each_with_index do |f, index|
          link_to_album << (f.search 'a').first.attributes["href"].text
        end

        link_to_album.each_with_index do |link,index|
          begin
            page = pages.link_with(href: link).click
            images = page.search('.foody-photo')
            images.each do |f|
              @images << f.attributes["href"].text
            end
          rescue

          end
        end

        respond_to do |format|
          format.html
          format.docx do
            render docx: 'index', filename: 'index.docx'
          end
        end
      end      
    rescue Exception => e
      
    end

  end

  # GET /craws/1
  # GET /craws/1.json
  def show
  end

  # GET /craws/new
  def new
    @craw = Craw.new
  end

  # GET /craws/1/edit
  def edit
  end

  # POST /craws
  # POST /craws.json
  def create
    @craw = Craw.new(craw_params)

    respond_to do |format|
      if @craw.save
        format.html { redirect_to @craw, notice: 'Craw was successfully created.' }
        format.json { render :show, status: :created, location: @craw }
      else
        format.html { render :new }
        format.json { render json: @craw.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /craws/1
  # PATCH/PUT /craws/1.json
  def update
    respond_to do |format|
      if @craw.update(craw_params)
        format.html { redirect_to @craw, notice: 'Craw was successfully updated.' }
        format.json { render :show, status: :ok, location: @craw }
      else
        format.html { render :edit }
        format.json { render json: @craw.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /craws/1
  # DELETE /craws/1.json
  def destroy
    @craw.destroy
    respond_to do |format|
      format.html { redirect_to craws_url, notice: 'Craw was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_craw
      @craw = Craw.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def craw_params
      params.fetch(:craw, {})
    end
end
