Rails.application.routes.draw do
  devise_for :users,  :controllers => { registrations: 'user/registrations' }

  # For details on the DSL available within this file, see             
  # http://guides.rubyonrails.org/routing.html
  get '/dashboard' => 'dashboard#index', :as => :dashboard
  post '/dashboard/add_widget', to: 'dashboard#add_widget'

  resources :activities, :as => 'activities' do
    collection do
      get :swimming
      get :cycling
      get :running
      get :other
      get :reports_table
      get :reports_coverage
      get :reports_analysis
    end

    member do
      post :update
    end
  end

	root to: 'pages#index'
end
