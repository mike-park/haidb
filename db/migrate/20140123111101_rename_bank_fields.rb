class RenameBankFields < ActiveRecord::Migration
  def change
    rename_column(:registrations, :bank_account_nr, :iban)
    rename_column(:registrations, :bank_sort_code, :bic)
    change_column_default(:registrations, :payment_method, nil)
  end
end
