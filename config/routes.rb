Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root to: "homes#top"
  get "home/about", to: "homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    # resource 単数形にすると、/:idがURLに含まれなくなる。
    resource :favorite, only: [:create, :destroy]

    # destroyなどをする時、:idが必要となるため、resourcesにする。
    resources :book_comments, only: [:create, :destroy]
  end
  
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    # 復習: GETメソッドでURL「/followings」にアクセスされたら、relationshipsコントローラーのfollowingsアクションを実行する
    get "followings" => "relationships#followings"
  	get "followers" => "relationships#followers"
  end

  get "/search", to: "searches#search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end