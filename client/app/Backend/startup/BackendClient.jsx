import React from "react";
import { Provider } from "react-redux";

import getStore from "../store/store";
import Routes from "../containers/Routes";

export default props => {
  const store = getStore(props);
  console.log(props);
  return (
    <Provider store={store}>
      <Routes />
    </Provider>
  );
};
