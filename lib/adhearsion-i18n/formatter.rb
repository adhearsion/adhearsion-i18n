class AdhearsionI18n::Formatter < Adhearsion::CallController::Output::Formatter
  def ssml_for_text(argument, options = {})
    RubySpeech::SSML.draw(options){ argument }
  end
end
