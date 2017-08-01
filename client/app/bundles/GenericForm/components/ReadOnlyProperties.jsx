import React from 'react'

export default class ReadOnlyProperties extends React.Component {
  render() {
    const { propertyData } = this.props

    if (!propertyData.length) return null

    return(
      <div className='ReadOnlyProperties'>
        {propertyData.map(datum => {
          return(
            <p key={datum.property}>
              {datum.property}: {datum.value}
            </p>
          )
        })}
      </div>
    )
  }
}
