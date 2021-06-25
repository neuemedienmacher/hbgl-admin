import React, { Fragment } from "react";
import { useQuery } from "react-query";
import ReactTable from "react-table-v6";
import { api } from "../../constants/routes";

import "react-table-v6/react-table.css";

const columns = [
  {
    id: "checkbox",
    accessor: "",
    Cell: row => (<input type="checkbox" />),
    minWidth: 100
  },
  {
    Header: "Id",
    accessor: "id",
    defaultSortDesc: false
  },
  {
    Header: "Name",
    accessor: "label",
    filterable: true
  },
];

const FederalStates = () => {
  const { isLoading, isError, data, error } = useQuery("fetchFederalStates", async () => {
    const res = await fetch(api.federalStates);

    if (!res.ok) {
      throw new Error(`Laden fehlgeschlagen, ${res.statusCode} - ${res.status}`);
    }
    return await res.json();
  });

  if (isLoading) {
    return (<div>schön am laden hier</div>);
  }

  if (isError) {
    return (
      <Fragment>
        <div>schön am Erroren hier</div>
        <div>{JSON.stringify(error, null, 2)}</div>
      </Fragment>
    );
  }

  const tableData = data.data.map(state => ({ id: Number(state.id), label: state.attributes.label }));

  return (
    <ReactTable
      columns={columns}
      data={tableData}
      showPagination={tableData.length > 20}
    />);
};

export default FederalStates;
