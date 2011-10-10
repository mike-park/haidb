# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :event do
    category Event::LIS
    start_date Date.today
    display_name { "Level 1: #{start_date}" }
  end

  factory :full_event, :parent => :event do
    level 1
  end
  factory :event1, :parent => :event do
    level 1
  end
  factory :event3, :parent => :event do
    level 3
  end
  factory :event5, :parent => :event do
    level 5
  end
  factory :future_event, :parent => :event do
    start_date Date.tomorrow
  end
  
  sequence :start_date do |n|
    Date.new(2011, n, 5)
  end

  factory :angel do
    first_name 'Mike'
    last_name 'Park'
    email 'mikep@quake.net'
    gender Angel::MALE
  end
  
  factory :full_angel, :parent => :angel do
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

  sequence :email do |n|
    "person-#{n}@example.com"
  end
  sequence :alphabet do |n|
    (65+n).chr
  end
  

  factory :public_signup do
    registration
    terms_and_conditions '1'
  end

  factory :registration do
    event
    angel
  end

  factory :full_registration, :parent => :registration do
    public_signup
    special_diet true
    backjack_rental true
    sunday_stayover true
    sunday_meal true
    sunday_choice Registration::STAYOVER
    lift Registration::REQUESTED
    payment_method Registration::INTERNET
    bank_account_nr '123 456 789'
    bank_account_name 'Mike Park'
    bank_name 'Sparkasse Berlin'
    bank_sort_code '500 123 456'
    notes "some long\nmessage\nthat is multiline\n"
    completed true
    checked_in true
    approved true
    how_hear 'friend'
    previous_event 'weekend workshop'
  end

  # office authentication
  factory :staff do
    email 'normal@example.com'
    password 'somesecret1234'
    factory :admin do
      email 'admin@example.com'
      super_user true
    end
  end
end

