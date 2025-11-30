Rails.application.routes.draw do
  root 'dashboard#index'
  
  get 'files', to: 'files#index'
  get 'files/list', to: 'files#list'
  post 'files/upload', to: 'files#upload'
  
  get 'maintenance', to: 'maintenance#index'
  post 'maintenance/run', to: 'maintenance#run', as: 'run_maintenance'
  
  get 'thermal', to: 'thermal#index'
  
  post 'files/freeze', to: 'file_actions#freeze', as: 'freeze_file'
  post 'files/thaw', to: 'file_actions#thaw', as: 'thaw_file'
end
