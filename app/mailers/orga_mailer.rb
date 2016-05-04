# frozen_string_literal: true
class OrgaMailer < ActionMailer::Base
  add_template_helper(EmailHelper)

  # Mails to organization conctacts to inform them about clarat
  # @attr email Email object this is sent to
  def inform email
    # okay, because all contact_persons belong to the same organization
    orga = email.contact_people.first.organization
    @contact_person = email.contact_people.first
    @vague_title = email.vague_contact_title?
    @overview_href_suffix = "/organisationen/#{orga.slug || orga.id.to_s}"

    mail subject: t('.subject'),
         to: email.address,
         from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'
  end
end
