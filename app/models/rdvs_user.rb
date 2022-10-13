# frozen_string_literal: true

class RdvsUser < ApplicationRecord
  devise :invitable
  # Attributes
  enum status: { unknown: "unknown", waiting: "waiting", seen: "seen", excused: "excused", revoked: "revoked", noshow: "noshow" }
  NOT_CANCELLED_STATUSES = %w[unknown waiting seen noshow].freeze
  CANCELLED_STATUSES = %w[excused revoked].freeze

  # Relations
  belongs_to :rdv, touch: true, inverse_of: :rdvs_users
  belongs_to :user

  # Validations
  # Uniqueness validation doesn’t work with nested_attributes, see https://github.com/rails/rails/issues/4568
  # We do have on a DB constraint.
  validates :user_id, uniqueness: { scope: :rdv_id }

  # Hooks
  before_create :set_status_from_rdv
  after_initialize :set_default_notifications_flags
  before_validation :set_default_notifications_flags
  after_commit :update_users_count

  # Scopes
  scope :not_cancelled, -> { where(status: NOT_CANCELLED_STATUSES) }
  scope :order_by_user_last_name, -> { includes(:user).order("users.last_name ASC") }

  def update_users_count
    rdv.users_count = rdv.rdvs_users.not_cancelled.count
    rdv.save
  end

  def set_status_from_rdv
    return if rdv&.status.nil?

    self.status = rdv.status
  end

  def set_default_notifications_flags
    return if rdv&.motif.nil?

    self.send_lifecycle_notifications = rdv.motif.visible_and_notified? if send_lifecycle_notifications.nil?
    self.send_reminder_notification = rdv.motif.visible_and_notified? if send_reminder_notification.nil?
  end

  def new_raw_invitation_token
    invite! { |rdv_u| rdv_u.skip_invitation = true }
    raw_invitation_token
  end
end
