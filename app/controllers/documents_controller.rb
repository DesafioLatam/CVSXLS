class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)

    if @document.invalid?
     return render :new
    end

    @name = @document.name.downcase

    @document_type = File.extname @document.file.path

    if @document_type == '.csv'
      Csv2json::csv_to_json @document.file.path
    elsif (@document_type == '.xls' || @document_type == '.xlsx')
      Xls2json::xls_to_json @document.file.path
    end

    case @name
    when 'regions', 'regiones', 'region'
      read_regions
    when 'provincia', 'provincias', 'province', 'provinces'
      read_provinces
    when 'comunas', 'comuna', 'commune', 'communes'
      read_communes
    when 'sector', 'sectores', 'sectors'
      read_sectors
    end

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:name, :file)
    end

    #rails g model sector name:string code:string commune:references
    def read_sectors
      path = 'public/json/sector.json'
      json = JSON.parse(File.open(path).read)

      communes = Commune.all
      Sector.delete_all
      json.each do |data|
        unless data['nombre_comuna'].nil?
          commune = communes.select{|comuna| comuna.name.casecmp(data['nombre_comuna']) == 0}.first
          Sector.create(name: data['nombre_sector'], code: data['cod_sector'], commune: commune)
        end
      end
    end

    #rails g model comuna name:string province:references
    def read_communes
      path = 'public/json/comunas.json'
      json = JSON.parse(File.open(path).read)

      Commune.delete_all
      json.each do |data|
        Commune.create(name: data["nombre"], province_id: data["provincia_id"], id: data["id"])
      end
    end

    #rails g model provincia name:string region:references
    def read_provinces
      path = 'public/json/provincias.json'
      json = JSON.parse(File.open(path).read)

      Province.delete_all
      json.each do |data|
        Province.create(name: data["nombre"], region_id: data["region_id"], id: data["id"])
      end
    end

    #rails g model region number:string name:string title:string
    def read_regions
      path = 'public/json/regions.json'
      json = JSON.parse(File.open(path).read)

      Region.delete_all
      json.each do |data|
        Region.create(number: data['numero'], name: data['nombre'], title: data['titulo'], id: data["id"])
      end

    end
end
