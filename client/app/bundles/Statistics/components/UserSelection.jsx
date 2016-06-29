import React, { PropTypes } from 'react'

export default class UserSelection extends React.Component {
  static propTypes = {
		users: PropTypes.array.isRequired,
		selectedUsers: PropTypes.array.isRequired,
	}

  render() {
    const {
			users, selectedUsers, toggleUser
    } = this.props

    return (
      <div className='UserSelection'>
				{users.map( (user) => {
          return (
            <span key={user.id} className='UserSelection--User'>
              <input
                type='checkbox'
                id={`user-${user.id}`}
                name='selectedUsers'
                checked={selectedUsers.includes(user.id)}
                onClick={toggleUser(user.id)}
              />
              <label htmlFor={`user-${user.id}`}>
                {user.name}
              </label>
            </span>
          )
				})}
      </div>
    )
  }
}
