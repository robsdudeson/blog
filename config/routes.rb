Rails.application.routes.draw do
  devise_for :users, controllers: {
      sessions: 'users/sessions'
  }
  get 'welcome/index'

  resources :articles do
    resources :comments
  end

  resources :chatrooms do
    resources :messages
  end

  root 'welcome#index'
end
