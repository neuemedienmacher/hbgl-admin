import React, { PropTypes, Component } from 'react'
import ShowItems from '../containers/ShowItems'

export default class Show extends Component {
  componentWillReceiveProps(nextProps) {
    if (nextProps.model != this.props.model || nextProps.id != this.props.id) {
      // console.log('componentWillReceiveProps!')
      this.props.loadData(nextProps.model, nextProps.id)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      location, id, model, heading
    } = this.props
    return (
      <div className='content Show'>
        <h3>{heading}</h3>
        <hr />
        <ShowItems model={model} id={id} params={location.query} />
      </div>
    )
  }
}
