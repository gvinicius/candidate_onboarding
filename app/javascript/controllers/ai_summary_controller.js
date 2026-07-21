import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "button", "spinner", "error", "apiKeyInput", "apiKeyField"]
  static values = { url: String }

  async generate() {
    this.buttonTarget.disabled = true
    this.spinnerTarget.classList.remove("hidden")
    this.errorTarget.textContent = ""

    const body = new FormData()
    body.append("authenticity_token", document.querySelector("meta[name='csrf-token']").content)

    if (this.hasApiKeyInputTarget && this.apiKeyInputTarget.value) {
      body.append("anthropic_api_key", this.apiKeyInputTarget.value)
    }

    try {
      const res = await fetch(this.urlValue, { method: "POST", body })
      const data = await res.json()
      if (data.summary) {
        this.textareaTarget.value = data.summary
      } else {
        this.errorTarget.textContent = data.error || "Failed to generate summary."
      }
    } catch {
      this.errorTarget.textContent = "Network error. Please try again."
    } finally {
      this.buttonTarget.disabled = false
      this.spinnerTarget.classList.add("hidden")
    }
  }
}
