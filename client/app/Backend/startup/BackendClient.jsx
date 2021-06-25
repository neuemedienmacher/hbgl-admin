import React from "react";
import { Provider } from "react-redux";
import { QueryClientProvider, QueryClient } from "react-query";

import getStore from "../store/store";
import Routes from "../containers/Routes";

const queryClient = new QueryClient();

export default props => {
  const store = getStore(props);

  return (
    <QueryClientProvider client={queryClient}>
      <Provider store={store}>
        <Routes />
      </Provider>
    </QueryClientProvider>
  );
};
