import { connect } from "react-redux";
import Dashboard from "../components/Dashboard";

const mapStateToProps = state => ({
  user: state.entities.users[state.entities["current-user-id"]]
});

export default connect(mapStateToProps)(Dashboard);
