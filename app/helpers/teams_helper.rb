module TeamsHelper
  def team_avatar(team, options={})
    size = options[:size] || 48
    classes = options[:class]

    if team.personal? && team.owner_id == current_user&.id
      image_tag avatar_url_for(team.users.first, options), class: classes

    elsif team.avatar.attached?
      image_tag team.avatar.variant(combine_options: {
        thumbnail: "#{size}x#{size}^",
        gravity: "center",
        extent: "#{size}x#{size}"
      }),
      class: classes
    else
      content = content_tag(:span, team.name.to_s.first, class: "initials")

      if options[:include_user]
        content += image_tag(avatar_url_for(current_user), class: "avatar-small")
      end

      content_tag :span, content, class: "avatar bg-blue-500 #{classes}"
    end
  end

  def team_member_roles(team, team_member)
    roles = []
    roles << "Owner" if team.owner_id == team_member.user_id
    TeamMember::ROLES.each do |role|
      roles << role.to_s.humanize if team_member.public_send(:"#{role}?")
    end
    roles
  end
end
