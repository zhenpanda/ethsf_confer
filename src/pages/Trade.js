import React, {Component} from 'react';

import {connect} from 'react-redux';
import * as actions from '../actions/index';

import Header from './Header';
import Body from './Body';

class Trade extends Component {

    render() {
        return(
            <div className="container">

                <Header 
                    displayTargetSide={this.displayTargetSide}
                    switchUser={this.props.switchUser}
                    user={this.props.user}
                />
                <Body 
                    proof={this.props.proof}
                    makeProof={this.props.makeProof}
                    user={this.props.user}
                    moveStage={this.props.moveStage}
                    stage={this.props.stage}
                />
            
            </div>
        )
    }
}
function mapStateToProps(state) {
    // console.log(state);
    return {
        proof: state.test.data,
        user: state.user.data,
        stage: state.stage.data
    }
  }
  export default connect(mapStateToProps, actions)(Trade);