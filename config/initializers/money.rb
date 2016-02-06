require 'money'
require 'money/bank/google_currency'

# @eu_bank = EuCentralBank.new
# @google_currency = Money::Bank::GoogleCurrency.new
# Money.default_bank = @google_currency
Money.default_bank = Money::Bank::GoogleCurrency.new
# (optional)
# set the seconds after than the current rates are automatically expired
# by default, they never expire
# Money::Bank::GoogleCurrency.ttl_in_seconds = 86400