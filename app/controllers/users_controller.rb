class UsersController < ApplicationController
    def index

        render :json => {
            message: 'Confidential'
        }
    end

    def show
        if User.exists?(params[:id])
            userId = User.find(params[:id])
            agentName = userId.surname
            message = "Welcome back Agent #{agentName}"
        else
            message = "Unauthorized access!"
        end

        render :json => {
            message: message
        }
            
    end


end
