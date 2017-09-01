import React, { PropTypes, Component } from 'react'
import ShowItems from '../containers/ShowItems'
import MemberActionsNavBar from
  '../../MemberActionsNavBar/containers/MemberActionsNavBar'

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
      location, id, model
    } = this.props
    return (
      <div className='content Show'>
        <MemberActionsNavBar model={model} id={id} location={location} />
        <ShowItems model={model} id={id} params={location.query} />
      </div>
    )
  }
}
