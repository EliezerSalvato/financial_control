module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages? || flash[:alert].present?

    sentence = flash[:alert] || I18n.t("errors.messages.not_saved")
    html = html_error_message(sentence)

    html.html_safe
  end

  private

  def devise_error_messages?
    !resource.errors.empty?
  end

  def html_error_message(sentence)
    <<-HTML
      <div class="notification is-danger notification-margin">
        <button class="delete"></button>
        <p>
          <i class="fas fa-times"></i>
          #{sentence}
        </p>
      </div>
      <script>
        document.querySelector(".notification .delete").addEventListener("click", function(event) {
          event.preventDefault();
          this.parentElement.style.display = "none";
        });
      </script>
    HTML
  end
end
