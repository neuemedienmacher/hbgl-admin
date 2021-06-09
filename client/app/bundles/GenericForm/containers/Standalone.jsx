import { connect } from "react-redux";
import parseLocation from "../lib/parseLocation";
import Standalone from "../components/Standalone";

const mapStateToProps = (state, ownProps) => {
  const [model, idOrNew, edit] = parseLocation(ownProps);
  const id = edit ? idOrNew : null;

  return {
    model,
    id,
    location: ownProps.location,
  };
};

export default connect(mapStateToProps)(
  Standalone
);
