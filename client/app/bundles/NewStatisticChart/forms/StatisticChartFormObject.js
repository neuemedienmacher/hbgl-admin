import { FormObject, JsonApiAdapter } from 'rform'

export default class StatisticChartFormObject extends FormObject {
  static get model() {
    return 'statistic_chart'
  }

  static get properties() {
    return [
      'user-team-id', 'target-model', 'target-field-name', 'target-field-value',
      'target-count', 'starts-at', 'ends-at', 'title'
    ]
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('user-team-id').filled()
    this.required('title').filled()
    this.required('target-count').filled('int?')
  }
}
