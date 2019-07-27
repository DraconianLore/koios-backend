# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    render json: {
      message: 'Confidential'
    }
  end

  def show
    if User.exists?(params[:id])
      userId = User.find(params[:id])
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
