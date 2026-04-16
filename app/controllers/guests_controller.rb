class GuestsController < ApplicationController
	
	inherit_resources
	load_and_authorize_resource
	
	has_scope :by_name, :by_surname, :by_email, :by_country

	respond_to :html, :json
	
	after_action :set_comming_from, only: :edit
	
	skip_before_action :authenticate_user, only: [:auto_edit, :update, :not_access_allowed, :auto_update_success]
	before_action :authenticate_token, only: [:auto_edit]
	
	def index
		@guests = (current_user.admin? || current_user.doctor? || current_user.viewer? || current_user.coord_eventer? || current_user.hoster?) ? Guest.all : (current_user.coord_outside? ? Guest.by_outside(true) : Guest.by_country(current_user.country).by_outside(false))
		@guests = params[:q] ? @guests.where("name ILIKE :query OR surname ILIKE :query OR email ILIKE :query OR concat_ws(' ', name, surname) ILIKE :query", {query: "%#{params[:q]}%"}).page(params[:page]) : apply_scopes(@guests).order(:name).page(params[:page])
		respond_to do |format|
			format.html
			format.json  {render :json => @guests.map(&:attributes)}
		end
	end

	def new
		@back_url = URI(request.referer || root_path).path
		new!
	end
	
	def edit
		@back_url = URI(request.referer || root_path).path
		edit!
	end
	
	def update
		update! do |success|
			success.html {
				if current_user
					flash[:notice] = "Contacto actualizado exitosamente"
				end
				redirect_to session[:previous_url]
			}
		end
	end
	
	def auto_edit
		session[:profile] = "eventer"
		session[:previous_url] = auto_update_success_guests_path()
	end
	
	def auto_update_success
		
	end
	
	def not_access_allowed
	
	end
	
	def create
		@guest = Guest.new(guest_params)
	  @guest.save
		flash[:notice] = "Contacto creado exitosamente"
	  redirect_to guests_path
	end
	
	private

    def guest_params
      params.require(:guest).permit(:name, :surname, :email, :country, :city, :phone_number, :mobile_number, :identification, :civil_status, :profession, :nationality, :health_condition, :receive_drug, :symptoms, :contact_name, :contact_kin, :contact_number, :hotel, :local_number, :comments, :is_initiate, :age, :birth_date, :outside, :swami_name)
    end
    
    def set_comming_from
    	session[:previous_url] = URI(request.referer || '').path
    end
    
		def authenticate_token
			tokenControl = TokenControl.where(auth_token: params[:auth_token], guest_id: params[:id]).first
			return redirect_to not_access_allowed_guests_path if tokenControl.nil?
			@guest = tokenControl.guest
		end 

end