import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["employmentCheckbox", "salaryField", "percentageField"]

  connect() {
    this.employmentTypeChanged()
  }

  employmentTypeChanged() {
    const selected = this.employmentCheckboxTargets
      .filter(cb => cb.checked)
      .map(cb => cb.value)

    const hasEmployed    = selected.includes("employed")
    const hasSelfEmployed = selected.some(v => ["self_employed", "freelance", "percentage_based"].includes(v))

    if (this.hasSalaryFieldTarget)
      this.salaryFieldTarget.style.display = hasEmployed ? "" : "none"
    if (this.hasPercentageFieldTarget)
      this.percentageFieldTarget.style.display = hasSelfEmployed ? "" : "none"
  }
}
