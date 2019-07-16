module UsersHelper
  def birth_date_and_age(user)
    return unless user.birth_date

    "#{l(user.birth_date)} - #{user.age}"
  end

  def add_user_button(btn_style = 'btn-primary')
    link_to 'Ajouter un usager', new_organisation_user_path, class: "btn #{btn_style}", data: { rightbar: true } if policy(User).create?
  end

  def formatted_phone_number(user)
    user.phone_number.chars.each_slice(2).map(&:join).join(' ') unless user.phone_number.blank?
  end

  def new_user_tag(user)
    content_tag(:span, 'Nouveau', class: 'badge badge-info') unless user.rdvs.any?
  end

end
