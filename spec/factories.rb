# -*- coding: utf-8 -*-

FactoryGirl.define do

  factory :event do
    category 'HAI LIS Workshop'
    start_date Date.today
    display_name { "Level 1: #{start_date}" }

    factory :full_event do
      level 1
      next_registration_code '123'
      participant_cost 110.98
      team_cost 99.12
    end
    factory :event1 do
      level 1
    end
    factory :event2 do
      level 2
    end
    factory :event3 do
      level 3
    end
    factory :event5 do
      level 5
    end
    factory :future_event do
      start_date Date.tomorrow
    end
    factory :past_event do
      start_date Date.yesterday
    end
  end

  factory :email_name do
    sequence(:name) { |n| "email name#{n}" }
  end

  factory :email, aliases: [:en_email] do
    email_name
    locale "en"
    subject "Subject"
    body "Body"

    factory :de_email do
      locale 'de'
      subject "Betreff"
      body "Inhalt"
    end
  end

  factory :event_email do
    category 'Signup'
    event
    email_name
  end

  sequence :start_date do |n|
    Date.new(2011, n, 5)
  end

  factory :angel do
    first_name 'Mike'
    sequence(:last_name) { |n| "Lastname#{n}" }
    sequence(:email) { |n| "angel#{n}@example.com" }
    gender 'Male'

    factory :full_angel do
      last_name 'Park'
      email 'mikep@quake.net'
      address 'Somewhere 140'
      postal_code '12345'
      city 'Berlin'
      country 'DE'
      home_phone '030 12345'
      mobile_phone '0151 1234'
      work_phone '+49 151 5678'
      notes "some long\nmessage\nthat is multiline\n"
      lang :en
    end
  end

  factory :public_signup do
    registration
    terms_and_conditions '1'
  end

  factory :registration do
    event
    first_name 'Mike'
    sequence(:last_name) { |n| "Lastname#{n}" }
    sequence(:email) { |n| "angel#{n}@example.com" }
    gender 'Male'

    factory :full_registration do
      angel
      address { angel.address }
      postal_code { angel.postal_code }
      city { angel.city }
      country { angel.country }
      home_phone { angel.home_phone }
      mobile_phone { angel.mobile_phone }
      work_phone { angel.work_phone }
      lang { angel.lang }
      special_diet 'Vegan'
      backjack_rental true
      sunday_stayover true
      sunday_meal true
      sunday_choice 'Stayover'
      lift 'Requested'
      payment_method 'Debt'
      bank_account_name 'Mike Park'
      iban 'GR16 0110 1250 0000 0001 2300 695'
      bic 'DEUTDEFF'
      notes "some long\nmessage\nthat is multiline\n"
      status Registration::APPROVED
      completed true
      checked_in true
      how_hear 'friend'
      previous_event 'weekend workshop'
    end
  end

  # office authentication
  factory :staff do
    sequence(:email) { |n| "staff#{n}@example.com" }
    password 'somesecret1234'

    factory :admin do
      super_user true
    end
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'someuserpassword'
  end

  factory :membership do
    angel
    status Membership::AWS
    active_on { Date.yesterday }
  end

  factory :team do
    sequence(:name) { |n| "Team L#{n}" }
    sequence(:date) { |n| Date.tomorrow + (n*2).weeks }
  end

  factory :member do
    angel
    team
    membership
    full_name "John Smith"
    gender "Male"
  end

end

