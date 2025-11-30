Rails.application.routes.draw do
  root 'dashboard#index'
  get 'files', to: 'files#index'
end
