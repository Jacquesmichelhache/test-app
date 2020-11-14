Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get 'customers/activityTypes', to: 'customers#activity_types'

  resources :customers

 


 
end
