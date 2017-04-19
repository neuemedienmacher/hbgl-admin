import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import isArray from 'lodash/isArray'
import AssociationItems from '../containers/AssociationItems'
import ShowFieldItem from '../containers/ShowFieldItem'

export default class ShowItems extends React.Component {
  render() {
    const {
      model_instance, associations, column_names, loaded
    } = this.props

    if(loaded){
      return (
        <div className="content ShowList">
          <div className="panel-group">
            <h5 className="section-title">Eigene Felder</h5>
            {column_names.map(name =>
              <ShowFieldItem key={name} name={name} content={model_instance[name]}/>
            )}
          </div>
          <AssociationItems model_instance={model_instance} associations={associations}/>
        </div>
      )
    }
    else{
      return <div className='text-center'>Lade...</div>
    }
  }
}
