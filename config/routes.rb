# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations confirmations], controllers: {
    sessions: "users/sessions",
  }

  devise_scope :user do
    get "/users/confirm_sign_in", to: "users/sessions#redirect_from_magic_link"
    post "/users/sign_in_with_token", to: "users/sessions#sign_in_with_token"
  end

  get "/pages/:page", to: "pages#show"
  get "check" => "application#check"

  root "start#index"
  get "/check-account", to: "check_account#show"

  resource :cookies, only: %i[show update]
  resource :privacy_policy, only: %i[show update], path: "privacy-policy"
  resource :accessibility_statement, only: :show, path: "accessibility-statement"
  resource :dashboard, controller: :dashboard, only: :show
  resource :supplier_dashboard, controller: :supplier_dashboard, only: :show

  namespace :api do
    resources :school_search, only: %i[index]
  end

  namespace :demo do
    resources :school_search, only: %i[index]
  end

  scope :nominations, module: :nominations do
    resource :notify_callback, only: :create, path: "notify-callback"
    resource :request_nomination_invite, controller: :request_nomination_invite, only: [], path: "/" do
      collection do
        get "choose-location", action: :choose_location
        post "choose-location", action: :receive_location
        get "choose-school", action: :choose_school
        post "choose-school", action: :receive_school
        get "review", action: :review
        post "review", action: :create
        get "success", action: :success
        get "not-eligible", action: :not_eligible
        get "limit-reached", action: :limit_reached
        get "already-nominated", action: :already_nominated
      end
    end
    resource :nominate_induction_coordinator, controller: :nominate_induction_coordinator, only: %i[new create], path: "/" do
      collection do
        get "start", action: :start
        get "email-used", action: :email_used
        get "link-expired", action: :link_expired
        post "link-expired", action: :resend_email_after_link_expired
        get "link-invalid", action: :link_invalid
        get "nominate-school-lead-success", action: :nominate_school_lead_success
      end
    end
  end

  namespace :lead_providers, path: "lead-providers" do
    resources :your_schools, only: %i[index create]
    resources :school_details, only: %i[show]

    resource :report_schools, path: "report-schools", only: [] do
      get "start", action: :start
    end
  end

  namespace :admin do
    resources :schools, only: %i[index show]

    scope :suppliers, module: "suppliers" do
      resources :suppliers, only: :index, path: "/"
      scope "new" do
        resources :delivery_partners, only: [], path: "delivery-partner" do
          collection do
            get "choose-name", action: :choose_name
            post "choose-name", action: :receive_name
            get "choose-lps", action: :choose_lead_providers
            post "choose-lps", action: :receive_lead_providers
            get "choose-cohorts", action: :choose_cohorts
            post "choose-cohorts", action: :receive_cohorts
            get "review", action: :review_delivery_partner
            post "/", action: :create_delivery_partner
          end
        end
      end
      resources :supplier_users, only: %i[index new create destroy], path: "users" do
        member do
          get "delete", action: :delete
        end
      end
      scope "users/new" do
        post "/", controller: :supplier_users, action: :receive_supplier
        get "user-details", controller: :supplier_users, action: :user_details, as: :new_supplier_user_details
        post "user-details", controller: :supplier_users, action: :receive_user_details
        get "review", controller: :supplier_users, action: :review, as: :new_supplier_user_review
      end

      resources :delivery_partners, only: %i[edit update destroy], path: "delivery-partners" do
        member do
          get "delete", action: :delete
        end
      end

      scope path: "lead-providers" do
        resources :lead_provider_users, only: %i[edit update destroy], path: "users" do
          member do
            get "delete", action: :delete
          end
        end
      end
    end

    scope :administrators, module: "administrators" do
      resources :administrators, only: %i[index new create edit update destroy], path: "/" do
        collection do
          post "new/confirm", action: :confirm, as: :confirm
        end

        member do
          get "delete", action: :delete
        end
      end
    end

    resources :induction_coordinators, only: %i[index edit update new], path: "induction-coordinators"
  end

  namespace :schools do
    resource :dashboard, controller: :dashboard, only: :show, path: "/"
    resource :choose_programme, controller: :choose_programme, only: %i[show create], path: "choose-programme" do
      member do
        get "advisory"
      end
    end
    resources :cohorts, only: :show do
      resources :partnerships, only: :index
      resource :programme, only: %i[edit], controller: "choose_programme"

      namespace :core_programme, path: "core-programme" do
        resource :materials, only: %i[edit update show] do
          get :info
          get :success
        end
      end

      member do
        get "programme-choice", as: :programme_choice
        get "add-participants", as: :add_participants
      end
    end
  end

  get "/403", to: "errors#forbidden", via: :all
  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all

  resource :school_search, only: %i[show create], path: "school-search", controller: :school_search
end
