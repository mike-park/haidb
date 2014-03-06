namespace :haidb do
  namespace :angels do
    desc "Merge duplicate angel records"
    task merge: :environment do
      Angel.merge_and_delete_duplicates
    end
  end

  namespace :audit do
    desc "Trim audit log"
    task trim: :environment do
      Audit.where(action: %w(create update)).where('created_at < ?', Date.today - 6.months).delete_all
    end
  end
end
