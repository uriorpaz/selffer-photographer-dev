Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin_area', as: 'rails_admin'
  root 'events#index'
  devise_for :admins
  devise_for :photographers, controllers: {passwords:'photographers/passwords' }
  resources :photographers, only: :show do
    get :profile
    post :upd, on: :collection
    get '/', to: 'events#index', as: :events
  end
  resources :events, except: [:index] do
    resources :photos, only: [:index, :create, :update] do
      get :find_faces, :processed, :toggle_tag
    end
    resources :invites, except: [:edit, :update, :new]
    resources :guest_invites, except: [:edit, :update, :new] do
      get :share
      post :upload_csv, on: :collection
    end
    resources :upload_logs, only: [:create, :update]
    resources :error_logs, only: :create
    post :delete_photos, :add_backgrounds, :share, :add_tag, :publish
    get :post_service, :photo_dup, :set_backgrounds
    # post '' => 'events#show'
  end
end
