module PolicyTestUtils
  def allows method_name
    subject.must_be method_name
  end

  def denies method_name
    subject.wont_be method_name
  end

  def allows_everything
    allows :create?
    allows :update?
    allows :destroy?
  end

  def denies_everything
    denies :create?
    denies :update?
    denies :destroy?
  end
end
