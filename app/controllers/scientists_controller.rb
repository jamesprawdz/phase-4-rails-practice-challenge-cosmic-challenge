class ScientistsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    wrap_parameters format: []
    
    def index
        scientists = Scientist.all
        render json: scientists
    end

    def show
        render json: find_scientist, serializer: ScientistWithPlanetsSerializer
    end

    def create 
        scientist = Scientist.create!(scientist_params)
        render json: scientist, status: :created
    end
    
    def update
        find_scientist.update!(scientist_params)
        render json: find_scientist, status: :accepted
    end

    def destroy
        find_scientist.destroy
        head :no_content
    end

    private
    
    def find_scientist
        scientist = Scientist.find(params[:id])
    end
    
    # create
    def render_unprocessable_entity_response(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    # show, update, delete
    def render_not_found_response
        render json: { error: "Scientist not found" }, status: :not_found
    end

    def scientist_params 
        params.permit(:name, :field_of_study, :avatar)
    end
end
