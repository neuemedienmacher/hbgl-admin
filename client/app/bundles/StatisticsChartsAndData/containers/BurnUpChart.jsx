import { connect } from 'react-redux'
import setUiAction from '../../../Backend/actions/setUi'
import BurnUpChart from '../components/BurnUpChart'

const mapStateToProps = function(state, ownProps) {
  const CursorOffsetX = state.ui.CursorOffsetX && (state.ui.chartId ==
                        ownProps.chartId) ? state.ui.CursorOffsetX : null

  return {
    data: ownProps.data,
    chartId: ownProps.chartId,
    CursorOffsetX
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  handleMousePosition(CursorOffsetX, chartId) {
    dispatch(setUiAction('CursorOffsetX', CursorOffsetX))
    dispatch(setUiAction('chartId', chartId))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(BurnUpChart)
