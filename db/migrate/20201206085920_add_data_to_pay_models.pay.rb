# This migration comes from pay (originally 20200603134434)
class AddDataToPayModels < ActiveRecord::Migration[4.2]
  def change
    add_column :pay_subscriptions, :data, data_column_type
    add_column :pay_charges, :data, data_column_type
  end

  def data_column_type
    config = ActiveRecord::Base.configurations.configs_for(env_name: 'default', name: 'primary')

    case config.adapter
    when "mysql2"
      :json
    when "postgresql"
      :jsonb
    else
      :text
    end
  end
end
