import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import isArray from 'lodash/isArray'
import AssociationItems from '../containers/AssociationItems'
import ShowFieldItem from '../containers/ShowFieldItem'
import History from '../containers/History'

export default class ShowItems extends Component {
  render() {
    const {
      modelInstance, associations, columnNames, loaded, model
    } = this.props

    if (loaded) {
      return(
        <div className="content ShowList">
          <div className="panel-group">
            <h5 className="section-title">Eigene Felder</h5>
            {columnNames.map(name =>
              <ShowFieldItem
                key={name} name={name} content={modelInstance[name]}
              />
            )}
          </div>
          <AssociationItems
            modelInstance={modelInstance} associations={associations}
            model={model}
          />
          <History model={model} parent={modelInstance} />
        </div>
      )
    } else{
      return <div className='text-center'>Lade...</div>
    }
  }
}
