module ApplicationHelper
  def accept_invite
    if cookies[:invite_code]
      @invite = Invite.find_by_code(cookies[:invite_code])
      if @invite
        if @invite.invited_email==current_photographer.email
          @invite.update(code: nil)
        else
          flash[:error] = "Wrong email"
        end
      else
        flash[:error] = "Wrong code"
      end
      cookies[:invite_code]=nil
      true
    end
  end

  def t(key, additional = {}, *models)
    hsh = TranslationService.get_attributes(*models)
    hsh.merge!(additional)
    super(key, hsh)
  end
end
