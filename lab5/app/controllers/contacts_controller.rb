class ContactsController < ApplicationController
  before_action :set_contact, only: %i[show edit update destroy]

  def index
    @contacts = Contact.all
  end

  def show
  end

  def new
    @contact = Contact.new
    @contact.phone_numbers.build
  end

  def edit
    @contact.phone_numbers.build if @contact.phone_numbers.empty?
  end

  def create
    @contact = Contact.new(contact_params)

    user = User.find_by(name: params[:contact][:name])

    if user.nil?
      user = User.create(name: params[:contact][:name])
      flash.now[:notice] = "User was created."
    end

    @contact.user = user

    if @contact.save
      flash[:notice] = "Contact was successfully created."
      redirect_to contacts_path
    else
      flash.now[:alert] = @contact.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to @contact, notice: "Contact successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path, notice: "Contact deleted."
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, phone_numbers_attributes: [:id, :number, :_destroy])
  end


end
