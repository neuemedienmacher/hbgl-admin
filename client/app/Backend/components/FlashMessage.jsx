import React, { PropTypes } from 'react'

/* UI Behaviour, related to CSS */
// export const TRANSITION_TIME = 250
// export const FLASH_DISPLAY_TIME = 3000

export default class FlashMessage extends React.Component {
  static propTypes = {
    type: PropTypes.string.isRequired,
    text: PropTypes.string.isRequired,
    onExpire: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)
    this.componentDidMount = this.componentDidMount.bind(this)
  }

  componentDidMount() {
    const { onExpire } = this.props

    setTimeout(function() {
      onExpire()
    }, 3000)
  }

  render() {
    const { type, text } = this.props

    const className = `c-flash-list__item c-flash-list__item--${type}`

    let awesomeName = 'c-flash-list__icon'
    switch(type) {
    case 'notice':
    case 'success':
      awesomeName = awesomeName + ' fa fa-check'
      break
    case 'alert':
    case 'error':
    default:
      awesomeName = awesomeName + ' fa fa-exclamation-triangle'
    }

    return (
      <li className={className}>
        <p className={awesomeName} />
        <p className="c-flash-list__text">
          {text}
        </p>
      </li>
    )
  }
}
