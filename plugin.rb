# name: localize-email-notifications
# about: Sends email notifications in the user's locale
# version: 0.1
# authors: scossar


enabled_site_setting :localize_email_notifications_enabled

after_initialize do
  UserNotifications.class_eval do
    def signup(user, opts={})
      build_email(user.email,
                  template: "user_notifications.signup",
                  locale: user_locale(user),
                  email_token: opts[:email_token])
    end

    def signup_after_approval(user, opts={})
      build_email(user.email,
                  template: 'user_notifications.signup_after_approval',
                  email_token: opts[:email_token],
                  locale: user_locale(user),
                  new_user_tips: I18n.t('system_messages.usage_tips.text_body_template', base_url: Discourse.base_url, locale: locale))
    end

    def authorize_email(user, opts={})
      build_email(user.email,
                  template: "user_notifications.authorize_email",
                  locale: user_locale(user),
                  email_token: opts[:email_token])
    end

    def forgot_password(user, opts={})
      build_email(user.email,
                  template: user.has_password? ? "user_notifications.forgot_password" : "user_notifications.set_password",
                  locale: user_locale(user),
                  email_token: opts[:email_token])
    end

    def admin_login(user, opts={})
      build_email(user.email,
                  template: "user_notifications.admin_login",
                  locale: user_locale(user),
                  email_token: opts[:email_token])
    end

    def account_created(user, opts={})
      build_email(user.email,
                  template: "user_notifications.account_created",
                  locale: user_locale(user),
                  email_token: opts[:email_token])
    end

    protected

    def user_locale(user)
      user.respond_to?(:locale) ? user.locale : nil
    end
  end
end