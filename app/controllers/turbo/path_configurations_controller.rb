class Turbo::PathConfigurationsController < ApplicationController
  # Defines the tabs and rules for the mobile app views
  # To customize this, you can edit the JSON here
  def show
    render json: {
      settings: {
        tabs: [
          {
            title: "What's New",
            path: "/announcements",
            system_image_name: "megaphone"
          }
        ]
      },
      rules: [
        {
          patterns: ["/new$", "/edit$"],
          properties: {
            presentation: "modal"
          }
        },
        {
          patterns: ["/users/sign_in"],
          properties: {
            flow: "authentication"
          }
        },
        {
          patterns: ["/account/password/edit"],
          properties: {
            flow: "update_password"
          }
        }
      ]
    }
  end
end
