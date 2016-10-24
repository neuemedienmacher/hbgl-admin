import { connect } from 'react-redux'
import ShowFieldItem from '../components/ShowFieldItem'

const mapStateToProps = (state, ownProps) => {
  const name = ownProps.name
  const content = ownProps.content
  const contentType = evaluateContentType(content, name)

  return {
    name,
    content,
    contentType
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function evaluateContentType(content, name) {
  let contentType = typeof content
  if (contentType == 'string' && timeStringRegex.test(content)) {
    contentType = 'time'
  }
  // else if (contentType == 'number'){
  //   let splitted_name = name.split('_')
  //   if (splitted_name.length > 1 && splitted_name[splitted_name.length-1] == 'id'){
  //     console.log(splitted_name)
  //   }
  // }
  // console.log(contentType)
  // console.log(name)
  return contentType
}

const timeStringRegex =
  /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}\+\d{2}:\d{2}$/

export default connect(mapStateToProps, mapDispatchToProps)(ShowFieldItem)
