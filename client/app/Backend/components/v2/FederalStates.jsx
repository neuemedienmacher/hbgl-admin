import React, { Fragment, useState } from 'react'
import { useQuery } from 'react-query'
import ReactTable from 'react-table-v6'
import { ButtonToolbar, ButtonGroup, Button } from 'react-bootstrap'
import { api } from '../../constants/routes'

import 'react-table-v6/react-table.css'

const FederalStates = () => {
  const [checkedRows, setCheckedRows] = useState([])

  const { isLoading, isError, data, error } = useQuery(
    'fetchFederalStates',
    async () => {
      const res = await fetch(api.federalStates)

      if (!res.ok) {
        throw new Error(
          `Laden fehlgeschlagen, ${res.statusCode} - ${res.status}`
        )
      }
      return await res.json()
    }
  )

  const columns = [
    {
      id: 'checkbox',
      accessor: '',
      Cell: ({ original }) => (
        <input
          type='checkbox'
          onClick={(e) => {
            if (e.currentTarget.checked) {
              setCheckedRows(checkedRows.concat([original.id]))
              return
            }
            setCheckedRows(checkedRows.filter((row) => row !== original.id))
          }}
        />
      ),
      maxWidth: 42,
    },
    {
      Header: 'Id',
      accessor: 'id',
      defaultSortDesc: false,
    },
    {
      Header: 'Name',
      accessor: 'label',
      filterable: true,
    },
  ]

  if (isLoading) {
    return <div>schön am laden hier</div>
  }

  if (isError) {
    return (
      <Fragment>
        <div>schön am Erroren hier</div>
        <div>{JSON.stringify(error, null, 2)}</div>
      </Fragment>
    )
  }

  const tableData = data.data.map((state) => ({
    id: Number(state.id),
    label: state.attributes.label,
  }))

  return (
    <Fragment>
      <ButtonToolbar>
        <ButtonGroup>
          <Button disabled={true}>Hinzufügen</Button>
          <Button disabled={true}>Bearbeiten</Button>
          <Button disabled={checkedRows.length === 0}>Entfernen</Button>
        </ButtonGroup>
      </ButtonToolbar>
      <ReactTable
        columns={columns}
        data={tableData}
        showPagination={tableData.length > 20}
      />
    </Fragment>
  )
}

export default FederalStates
