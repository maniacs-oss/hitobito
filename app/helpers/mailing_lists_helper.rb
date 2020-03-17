# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module MailingListsHelper

  def format_mailing_list_preferred_labels(mailing_list)
    safe_join mailing_list.preferred_labels.sort, ', '
  end

  def button_toggle_subscription
    if entry.subscribable?
      if entry.subscribed?(current_user)
        button_subscribe
      else
        button_unsubscribe
      end
    end
  end

  def format_mailchimp_sync(mailing_list)
    if mailing_list.mailchimp_last_synced_at
      state, badge_class = mailing_list.mailchimp_result.badge_info
      text = I18n.t("activerecord.attributes.mailing_list.mailchimp_states.#{state}")
      content_tag(:div) do
        content_tag(:span, I18n.l(mailing_list.mailchimp_last_synced_at, format: :short)) +  " " +
          content_tag(:span, badge(text, badge_class))
      end
    end
  end

  private

  def button_subscribe
    action_button(t('mailing_list_decorator.unsubscribe'),
                  group_mailing_list_user_path(@group, entry),
                  :minus,
                  method: 'delete')
  end

  def button_unsubscribe
    action_button(t('mailing_list_decorator.subscribe'),
                  group_mailing_list_user_path(@group, entry),
                  :plus,
                  method: 'post')
  end

end
