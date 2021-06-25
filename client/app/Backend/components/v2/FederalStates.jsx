import React, { Fragment } from "react";
import { useQuery } from "react-query";
import { api } from "../../constants/routes";

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
  console.log(data);

  return (<div>test</div>);
};

export default FederalStates;
