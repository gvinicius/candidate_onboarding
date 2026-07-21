import { Controller } from "@hotwired/stimulus"

const BIG_SLUGS = ["general_dentist", "dental_hygienist", "specialist"]

export default class extends Controller {
  static targets = [
    "jobFunctionSelect", "bigSection", "bigStatusSelect",
    "bigNumberField", "revenueField", "skillsContainer"
  ]

  connect() {
    this.jobFunctionChanged()
  }

  async jobFunctionChanged() {
    const select = this.jobFunctionSelectTarget
    const option = select.selectedOptions[0]
    const slug   = option?.dataset?.slug || ""

    this.toggleBigSection(BIG_SLUGS.includes(slug))
    this.toggleRevenueField(BIG_SLUGS.includes(slug))
    await this.loadSkills(select.value)
  }

  toggleBigSection(show) {
    if (!this.hasBigSectionTarget) return
    this.bigSectionTarget.style.display = show ? "" : "none"
  }

  toggleRevenueField(show) {
    if (!this.hasRevenueFieldTarget) return
    this.revenueFieldTarget.style.display = show ? "" : "none"
  }

  bigStatusChanged() {
    if (!this.hasBigNumberFieldTarget) return
    const status = this.bigStatusSelectTarget.value
    this.bigNumberFieldTarget.style.display = status === "big_registered" ? "" : "none"
  }

  async loadSkills(jobFunctionId) {
    if (!this.hasSkillsContainerTarget || !jobFunctionId) return
    const resp = await fetch(`/onboarding/skills?job_function_id=${jobFunctionId}`, {
      headers: { Accept: "text/vnd.turbo-stream.html, text/html" }
    })
    if (resp.ok) {
      const html = await resp.text()
      this.skillsContainerTarget.innerHTML = html
    }
  }
}
