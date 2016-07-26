# encoding: utf-8

module AdhearsionI18n::CallControllerMethods
  def t(key, options = {})
    AdhearsionI18n.t key, { locale: locale }.merge(options || {})
  end

  def locale
    call[:locale] || AdhearsionI18n.locale
  end

  def locale=(l)
    call[:locale] = l
  end
end
