class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.topic.public? || user.present?
  end

  def destroy?
    can_moderate?
  end
end