import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "item"]

  add(event) {
    const type      = event.currentTarget.dataset.nestedFormTemplateValue
    const timestamp = Date.now()
    const template  = document.getElementById(`${type}-template`)
    if (!template) return

    const html = template.innerHTML.replace(/NEW_RECORD/g, timestamp)
    this.containerTarget.insertAdjacentHTML("beforeend", html)
  }

  remove(event) {
    const item = event.currentTarget.closest("[data-nested-form-target='item']")
    if (!item) return

    const destroyField = item.querySelector(".destroy-field")
    if (destroyField) {
      destroyField.value = "1"
      item.style.display = "none"
    } else {
      item.remove()
    }
  }

  toggleEndDate(event) {
    const item     = event.currentTarget.closest("[data-nested-form-target='item']")
    const endDate  = item?.querySelector("input[type='date'][name*='end_date']")
    if (endDate) endDate.disabled = event.currentTarget.checked
  }
}
