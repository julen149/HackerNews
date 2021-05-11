class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    
    def authenticate
        if user = User.find_by_encrypted_password(request.headers["token"])
          @api_user = user
        else
          render_unauthorized
        end
    end
    
    def render_unauthorized
        render json: {:error => 'Unauthorized'}.to_json, :status => 401
    end
    
    def render_not_found
     render :json => {:error => "not-found"}.to_json, :status => 404
    end
end
