Rails.application.routes.draw do
  resources :tasks
  root 'top#index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :blogs do
    resources :comments

    collection do
      post :confirm
    end
  end

  resources :contacts, only: [:new, :create] do
    collection do
      post :confirm
    end
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: [:index, :show, :edit, :update] do
    resources :tasks
    resources :submit_requests , shallow: true do
      get 'approve'
      get 'unapprove'
      get 'reject'
      collection do
        get 'inbox'
      end
    end
  end

  resources :relationships, only: [:create, :destroy]

  resources :conversations do
    resources :messages
  end
end
