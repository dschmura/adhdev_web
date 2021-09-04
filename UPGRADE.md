### September 4, 2021 - Pay 3 upgrade

The Pay 3.0 upgrade migrates data from the Account model to the new Pay::Customer model and reassociates charges and subscriptions. It also switches generic trials to use the new `fake_processor` in Pay.

You can skip this if you aren't using payments in your app yet.

To upgrade, you'll want to do a few things:
1. Review `20210805001857_upgrade_to_pay_v3.rb`. This migration handles all the data migration to the new tables.
2. Test the migration against your local database. Sync your production database locally to test against it.
3. Test `rails pay:payment_methods:sync_default` in development to make sure it successfully syncs the default payment method for each customer.
4. Run the migration in production
5. Run `rails pay:payment_methods:sync_default` in production to sync default payment methods.
