grape-doorkeeper
================

[![Code Climate](https://codeclimate.com/github/fuCtor/grape-doorkeeper.png)](https://codeclimate.com/github/fuCtor/grape-doorkeeper)

Integration Grape with Doorkeeper

```ruby
class API < Grape::API
  helpers do
    def current_token; env['api.token'] end
    def current_user; @current_user ||= Acl::User.find(current_token.resource_owner_id) if current_token end
  end
  
  doorkeeper_for :all, scopes: [:read]
  
  get :hello do
    {:hello => current_user.email }
  end
  
  get :by, protected: false do
    {:by => 1 }
  end
  
  resource :statuses do
    get :count do
      {:count => 0 }
    end  
    
  end
end
```
