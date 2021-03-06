namespace :haidb do
  namespace :angels do
    desc "Merge duplicate angel records"
    task merge: :environment do
      Angel.merge_and_delete_duplicates
    end
  end

  namespace :memberships do
    desc 'Recalc membership status'
    task recalc: :environment do
      Membership.upgrade_memberships
    end
  end

  namespace :audit do
    desc "Trim audit log"
    task trim: :environment do
      Audited::Adapters::ActiveRecord::Audit.where(action: %w(create update)).where('created_at < ?', Date.today - 6.months).delete_all
    end
  end

  namespace :background do
    desc 'Perform daily cleanup'
    task daily: %w(angels:merge memberships:recalc audit:trim)
  end

  namespace :db do
    desc 'Pull live db to development'
    task pull: [] do
      %x(dropdb haidb_development)
      %x(env -i PATH=$PATH HOME=$HOME /usr/bin/heroku pg:pull haidb::BLUE haidb_development)
    end

    desc 'Apply incognito the db'
    task incognito: :environment do
      Incognito.apply
    end
  end
end
