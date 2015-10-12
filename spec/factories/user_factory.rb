FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "tester#{n}@tester.com" }
    password              'password'
    password_confirmation 'password'
    first_name            {Faker::Name.first_name}
    last_name             {Faker::Name.last_name}

    # factory :user_with_friends do
    #   transient do
    #     friends_count 5
    #   end
    #   after(:create) do |user, evaluator|
    #     create_list(:user, evaluator.friends_count).map{ |new_user| new_user.add_friend!(user)}
    #   end
    # end
  end
end
