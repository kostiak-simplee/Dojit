class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.topic.public? || user.present?
  end

  def destroy?
    user.present? && (record.user == user || user.admin? || user.moderator?)
  end
end