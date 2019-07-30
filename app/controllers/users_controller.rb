# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    render json: {
      message: 'Confidential'
    }
  end

  def show
    # Device ID to log in users - replace manual entry to restrict devices to a single account 
    # if User.exists?(deviceId: params[:id])
    #   userId = User.find_by deviceId: params[:id]
    # end deviceId Login

    # Manual user entry for DEMO purposes
    if User.exists?(params[:id])
      userId = User.find(params[:id])
    # end manual login section

      agentName = userId.surname
      message = "Welcome back Agent #{agentName}"
      exp = userId.experience
      rank = userId.rank
    else
      message = 'Unauthorized access!'
    end

    render json: {
      message: message,
      experience: exp,
      rank: rank
    }
  end
end
