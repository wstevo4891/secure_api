module Api
  module V1
    class TodosController < ApplicationController
      before_action :authenticate_user!
      before_action :set_todo, only: %i[ show edit update destroy ]

      # GET /todos
      def index
        render json: Todo.all
      end

      # GET /todos/1
      def show
        render json: @todo
      end

      # GET /todos/new
      def new
        render json: Todo.new
      end

      # GET /todos/1/edit
      def edit
        render json: @todo
      end

      # POST /todos
      def create
        @todo = Todo.new(todo_params)

        if @todo.save
          render json: @todo, status: :created
        else
          render json: @todo.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /todos/1
      def update
        if @todo.update(todo_params)
          render json: @todo, status: :ok
        else
          render json: @todo.errors, status: :unprocessable_entity
        end
      end

      # DELETE /todos/1
      def destroy
        @todo.destroy!

        render json: {
          resource: "Todo",
          id: @todo.id,
          message: "This record was successfully deleted."
        }
      rescue ActiveRecord::RecordNotDestroyed => e
        render json: e
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_todo
          @todo = Todo.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def todo_params
          params.expect(todo: [ :title, :completed ])
        end
    end
  end
end
