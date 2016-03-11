class OrgaMailer < ActionMailer::Base
  add_template_helper(EmailHelper)

  # Informing email addresses for the first time that they have offers listed on
  # our platform.
  # @attr email Email object this is sent to
  # @attr offers variable only for test mails
  # A lot of variables have to be prepared for the email, so we are OK with
  # a slightly higher assignment branch condition size and disable rubocop
  # rubocop:disable Metrics/AbcSize
  def inform email
    # okay, because all contact_persons belong to the same organization
    orga = email.contact_people.first.organization
    @contact_person = email.contact_people.first
    @vague_title = email.vague_contact_title?
    @overview_href_suffix = "/organisationen/#{orga.slug || orga.id.to_s}"

    mail subject: t(".subject"),
         to: email.address,
         from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'
  end
  # rubocop:enable Metrics/AbcSize
end
