class User::ProfileLoadInteraction < Interaction
  include User::Serializers

  def exec
    require_current_user!
    self
  end

  def as_json(opts = {})
    serialize_user current_user
  end
end
