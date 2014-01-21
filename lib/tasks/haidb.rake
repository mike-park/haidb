namespace :haidb do
  namespace :angels do
    desc "Merge duplicate angel records"
    task merge: :environment do
      Angel.merge_and_delete_duplicates
    end
  end
end
