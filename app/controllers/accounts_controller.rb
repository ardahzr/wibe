class AccountsController < ApplicationController
    before_action :authenticate_user!  # Giriş yapmamış kullanıcıları yönlendirir
  
    def show
      @user = current_user  # Giriş yapan kullanıcının bilgilerini alır
    end
  end
  